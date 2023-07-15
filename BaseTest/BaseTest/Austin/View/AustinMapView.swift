//
//  Austin.swift
//  BaseTest
//
//  Created by Seungui Moon on 2023/07/12.
//

import SwiftUI
import MapKit

struct AustinMapView: View {
    @State private var musicList: [MusicDummyItem] = []
    @State private var isMoving = true
    var body: some View {
        VStack {
            MapView(musicList: $musicList)
            if isMoving {
                if musicList.isEmpty {
                    ProgressView()
                        .frame(height: 300)
                } else {
                    AustinMapSearchMusicListModalView(musicList: $musicList)
                        .frame(height: 300)
                }
            }
        }
    }
}

struct AustinMapView_Previews: PreviewProvider {
    static var previews: some View {
        AustinMapView()
    }
}

struct MapView: UIViewRepresentable {
    @Binding var musicList: [MusicDummyItem]

    var annotaionDataList = annotaionDummyData
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.64422936785126, longitude: 142.39329541313924), span: MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 2))


    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            parent.musicList = []
        }
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            print(mapView.visibleAnnotations())
            var newAnnotaionList: [MusicDummyItem] = []
            for annotation in mapView.visibleAnnotations() {
                if let landmark = annotation as? LandmarkAnnotation {
                    newAnnotaionList.append(
                        MusicDummyItem(songName: landmark.songName ?? "", coverImageName: landmark.imageName ?? "", artistName: landmark.artistName ?? "", musicId: landmark.musicId ?? ""))
                }
            }
            parent.musicList = newAnnotaionList
        }
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
        
        for annotaionData in annotaionDataList {
            let annotation = LandmarkAnnotation(
                coordinate: annotaionData.coordinate,
                imageName: annotaionData.imageName ?? "",
                songName: annotaionData.songName ?? "",
                artistName: annotaionData.artistName ?? "",
                musicId: annotaionData.musicId ?? ""
            )
            view.addAnnotation(annotation)
        }
        
        return view
        
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    
}

extension MKMapView {
    func visibleAnnotations() -> [MKAnnotation] {
        return self.annotations(in: self.visibleMapRect).map { obj -> MKAnnotation in return obj as! MKAnnotation }
    }
}
struct SampleData: Identifiable {
    var id = UUID()
    var latitude: Double
    var longitude: Double
    var imageName: String?
    var songName: String?
    var artistName: String?
    var musicId: String?
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }
}

var annotaionDummyData = [
    SampleData(latitude: 43.70564024126748,longitude: 142.37968945214223,imageName: "annotaion0",songName: "BIG WAVE",artistName: "artist0", musicId: "1004836383"),
    SampleData(latitude: 43.81257464206404, longitude: 142.82112322464369, imageName: "annotaion1",songName: "BIG WAVE",artistName: "artist0", musicId: "1004836383"),
    SampleData(latitude: 43.38416585162576, longitude: 141.7252598737476, imageName: "annotaion2",songName: "BIG WAVE",artistName: "artist0", musicId: "1004836383"),
    SampleData(latitude: 45.29168643283501, longitude: 141.95286751470724, imageName: "annotaion3",songName: "BIG WAVE",artistName: "artist0", musicId: "1004836383")
]


class LandmarkAnnotation: NSObject, MKAnnotation {

    let coordinate: CLLocationCoordinate2D
    let imageName: String?
    var songName: String?
    var artistName: String?
    var musicId: String?

    init(
         coordinate: CLLocationCoordinate2D,
         imageName: String = "",
         songName: String = "",
         artistName: String = "",
         musicId: String = ""
    ) {
        self.coordinate = coordinate
        self.imageName = imageName
        self.songName = songName
        self.artistName = artistName
        self.musicId = musicId
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
        
        guard let landmark = annotation as? LandmarkAnnotation else {
            image = UIImage(named: "annotationImage")
            return
        }
        image = UIImage(named: "\(landmark.imageName ?? "annotationImage")")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
    }
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
        
        self.image = self.drawRatio(cluster)
    }
    
    private func drawRatio(_ cluster: MKClusterAnnotation) -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 70, height: 60))
        return renderer.image { ctx in
            
            let rect = CGRect(x: 0, y: 10, width: 50, height: 50)
            if let landmark = cluster.memberAnnotations.first as? LandmarkAnnotation {
                let img = UIImage(named: "\(landmark.imageName ?? "annotaionImage")")
                img?.draw(in: rect)
            } else {
                let img = UIImage(named: "annotaionImage")
                img?.draw(in: rect)
            }

            UIColor.white.setFill()
            
            UIBezierPath(ovalIn: CGRect(x: 35, y: 0, width: 20, height: 20)).fill()
            
            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
            let text = "\(cluster.memberAnnotations.count)"
            let size = text.size(withAttributes: attributes)
//            let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
            let textRect = CGRect(x: 40, y: 0, width: size.width, height: size.height)
            text.draw(in: textRect, withAttributes: attributes)
        }
    }
}
