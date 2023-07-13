//
//  AustinMapView.swift
//  BaseTest
//
//  Created by Seungui Moon on 2023/07/12.
//

import SwiftUI
import MapKit

struct AustinMapView: View {
    var body: some View {
//        MapView()
        Text("hewlf")
    }
}

struct AustinMapView_Previews: PreviewProvider {
    static var previews: some View {
        AustinMapView()
    }
}
//struct MapView: UIViewRepresentable {
//
//    var forDisplay = data
//    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.64422936785126, longitude: 142.39329541313924), span: MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 2))
//
//    class Coordinator: NSObject, MKMapViewDelegate {
//
//        var parent: MapView
//
//        init(_ parent: MapView) {
//            self.parent = parent
//        }
//
//    /// showing annotation on the map
//        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            guard let annotation = annotation as? LandmarkAnnotation else { return nil }
//            mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationView.ReuseID)
//            return AnnotationView(annotation: annotation, reuseIdentifier: AnnotationView.ReuseID)
//
//            switch annotation {
//                case is LocationViewModel:
//                    let view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation)
//                    view.clusteringIdentifier = String(describing: LocationDataMapAnnotationView.self)
//                    return view
//                case is MKClusterAnnotation:
//                    return mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: annotation)
//                default:
//                    return nil
//                }
//        }
//
//    }
//
//    func makeCoordinator() -> Coordinator {
//        MapView.Coordinator(self)
//    }
//
//
//    func makeUIView(context: Context) -> MKMapView {
//        ///  creating a map
//        let view = MKMapView()
//        /// connecting delegate with the map
//        view.delegate = context.coordinator
//        view.setRegion(region, animated: false)
//        view.mapType = .standard
//
//        for points in forDisplay {
//            let annotation = LandmarkAnnotation(coordinate: points.coordinate)
//            view.addAnnotation(annotation)
//        }
//        view.register(
//            AnnotationView.self,
//            forAnnotationViewWithReuseIdentifier:
//                AnnotationView.ReuseID
//        )
//
//        return view
//
//    }
//
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//
//    }
//}
//
//struct SampleData: Identifiable {
//    var id = UUID()
//    var latitude: Double
//    var longitude: Double
//    var coordinate: CLLocationCoordinate2D {
//        CLLocationCoordinate2D(
//            latitude: latitude,
//            longitude: longitude)
//    }
//}
//
//var data = [
//    SampleData(latitude: 43.70564024126748, longitude: 142.37968945214223),
//    SampleData(latitude: 43.81257464206404, longitude: 142.82112322464369),
//    SampleData(latitude: 43.38416585162576, longitude: 141.7252598737476),
//    SampleData(latitude: 45.29168643283501, longitude: 141.95286751470724),
//    SampleData(latitude: 45.49261392585982, longitude: 141.9343973160499),
//    SampleData(latitude: 44.69825427301145, longitude: 141.91227845284203)
//]
//
//
//class LandmarkAnnotation: NSObject, MKAnnotation {
//
//    let coordinate: CLLocationCoordinate2D
//
//    init(
//         coordinate: CLLocationCoordinate2D
//    ) {
//        self.coordinate = coordinate
//        super.init()
//    }
//
//}
//
//
///// here posible to customize annotation view
//let clusterID = "clustering"
//
//class AnnotationView: MKAnnotationView {
//    private let countLabel = UILabel()
//
//    override var annotation: MKAnnotation? {
//        didSet {
//             guard let annotation = annotation as? MKClusterAnnotation else {
//                assertionFailure("Using LocationDataMapClusterView with wrong annotation type")
//                return
//            }
//
//            countLabel.text = "\(annotation.memberAnnotations.count)"
//        }
//    }
//
//    static let ReuseID = "cultureAnnotation"
//
//    /// setting the key for clustering annotations
//    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
//        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        clusteringIdentifier = clusterID
//        guard let cluster = annotation as? MKClusterAnnotation else {
//            image = UIImage(named: "annotaionImage")
//            return
//        }
//
//        self.image = self.drawRatio(totalCount: cluster.memberAnnotations.count)
//    }
//    // 주석 클러스터링🍎
//    // 주석을 클러스터로 그룹화하려면 clusteringIdentifier 그룹의 각 주석 보기에 속성을 동일한 값으로 설정합니다. 예를 들어, 클러스터링 주석 보기에서 겹치는 clusterID 주석을 표시하기 위해 UnicycleAnnotationView의 각 인스턴스에 대한 clusteringIdentifier를 "clusterID" 로 설정합니다.
//
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func prepareForDisplay() {
//        super.prepareForDisplay()
//        displayPriority = .defaultLow
//
//    }
//    private func drawRatio(totalCount: Int) -> UIImage {
//        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
//        return renderer.image { _ in
//            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black,
//                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)]
//            let text = totalCount > 99 ? "99+" : "\(totalCount)"
//            let size = text.size(withAttributes: attributes)
//            let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
//            text.draw(in: rect, withAttributes: attributes)
//        }
//    }
//}
