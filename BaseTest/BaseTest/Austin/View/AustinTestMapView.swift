//
//  Austin.swift
//  BaseTest
//
//  Created by Seungui Moon on 2023/07/12.
//

import SwiftUI
import MapKit

struct AustinTestMapView: View {
    var body: some View {
        MapView()
    }
}

struct AustinTestMapView_Previews: PreviewProvider {
    static var previews: some View {
        AustinTestMapView()
    }
}

struct MapView: UIViewRepresentable {


    var forDisplay = data
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.64422936785126, longitude: 142.39329541313924), span: MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 2))


    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        
    /// showing annotation on the map
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            switch annotation {
            case is LandmarkAnnotation:
                return AnnotationView(annotation: annotation, reuseIdentifier: AnnotationView.ReuseID)
            case is MKClusterAnnotation:
                return ClusteringAnnotationView(annotation: annotation, reuseIdentifier: ClusteringAnnotationView.ReuseID)
            default:
                return nil
            }

        }
        func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
            let clusterAnnotaion = MKClusterAnnotation(memberAnnotations: memberAnnotations)
            clusterAnnotaion.title  = "clusted"
            return clusterAnnotaion
        }

    }

    func makeCoordinator() -> Coordinator {
        MapView.Coordinator(self)
    }


    func makeUIView(context: Context) -> MKMapView {
        ///  creating a map
        let view = MKMapView()
        /// connecting delegate with the map
        view.delegate = context.coordinator
        view.setRegion(region, animated: false)
        view.mapType = .standard
        
        for points in forDisplay {
            let annotation = LandmarkAnnotation(coordinate: points.coordinate)
            view.addAnnotation(annotation)
        }
        
        return view
        
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}

struct SampleData: Identifiable {
    var id = UUID()
    var latitude: Double
    var longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }
}

var data = [
    SampleData(latitude: 43.70564024126748, longitude: 142.37968945214223),
    SampleData(latitude: 43.81257464206404, longitude: 142.82112322464369),
    SampleData(latitude: 43.38416585162576, longitude: 141.7252598737476),
    SampleData(latitude: 45.29168643283501, longitude: 141.95286751470724),
    SampleData(latitude: 45.49261392585982, longitude: 141.9343973160499),
    SampleData(latitude: 44.69825427301145, longitude: 141.91227845284203)
]


class LandmarkAnnotation: NSObject, MKAnnotation {

    let coordinate: CLLocationCoordinate2D

    init(
         coordinate: CLLocationCoordinate2D
    ) {
        self.coordinate = coordinate
        super.init()
    }

}


/// here posible to customize annotation view
let clusterID = "clustering"

class AnnotationView: MKAnnotationView {

    static let ReuseID = "cultureAnnotation"

    /// setting the key for clustering annotations
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = clusterID
        image = UIImage(named: "annotaionImage")
    }
    // 주석 클러스터링🍎
    // 주석을 클러스터로 그룹화하려면 clusteringIdentifier 그룹의 각 주석 보기에 속성을 동일한 값으로 설정합니다. 예를 들어, 클러스터링 주석 보기에서 겹치는 clusterID 주석을 표시하기 위해 UnicycleAnnotationView의 각 인스턴스에 대한 clusteringIdentifier를 "clusterID" 로 설정합니다.


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
    }
    // 디스플레이 우선순위🍎
    // annotation 뷰가 다른 annotation 뷰와 겹칠 때 어떻게 동작하는지 확인하려면 displayPriority 속성을 설정합니다. clusterID의 displayPriority는 defaultLow로 설정되어 있기 때문에 MapView에서 다른 annotation들이 겹칠 경우 clusterID 주석을 숨길 것입니다.
}

final class ClusteringAnnotationView: MKAnnotationView {
    static let ReuseID = "ClusteringAnnotationView"
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This method cannot be called.")
    }
    override func prepareForDisplay() {
        super.prepareForDisplay()
        guard let cluster = annotation as? MKClusterAnnotation else { return }
        
        self.image = self.drawRatio(cluster.memberAnnotations.count)
    }
    
    private func drawRatio(_ totalCount: Int) -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 60, height: 60))
        return renderer.image { ctx in
            
            let rect = CGRect(x: 12, y: 12, width: 24, height: 24)
            let img = UIImage(named: "annotaionImage")
            img?.draw(in: rect)

            UIColor.white.setFill()
            let textRect = CGRect(x: 26, y: 0, width: 24, height: 24)
            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
            let text = "\(totalCount)"
            let size = text.size(withAttributes: attributes)
            text.draw(in: textRect, withAttributes: attributes)
        }
    }
}
