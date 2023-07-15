//
//  Austin.swift
//  BaseTest
//
//  Created by Seungui Moon on 2023/07/12.
//

import SwiftUI
import MapKit

struct AustinMapView: View {
    @State private var musicList: [MusicItem] = []
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
    @State private var region = startRegion
    @Binding var musicList: [MusicItem]

    var annotaionDataList = annotaionDummyData

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        /// 화면 이동중 musicList reset
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            self.setMusicList([])
        }
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            var newAnnotaionList: [MusicItem] = []
            for annotation in mapView.visibleAnnotations() {
                if let defaultAnnotation = annotation as? DefaultAnnotation {
                    newAnnotaionList.append(defaultAnnotation.getMusicItemFromAnnotation())
                }
            }
            setMusicList(newAnnotaionList)
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            switch annotation {
            case is DefaultAnnotation:
                return DefaultAnnotationView(annotation: annotation, reuseIdentifier: DefaultAnnotationView.ReuseID)
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
        private func setMusicList(_ newMusicList: [MusicItem]) {
            parent.musicList = newMusicList
        }
    }

    func makeCoordinator() -> Coordinator {
        MapView.Coordinator(self)
    }


    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView()
        view.delegate = context.coordinator
        view.setRegion(region, animated: false)
        view.mapType = .standard
        
        for annotaionData in annotaionDataList {
            let annotation = DefaultAnnotation(annotaionData)
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




/// here posible to customize annotation view
let clusterID = "clustering"

class DefaultAnnotationView: MKAnnotationView {

    static let ReuseID = "cultureAnnotation"

    /// setting the key for clustering annotations
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = clusterID
        
        guard let landmark = annotation as? DefaultAnnotation else {
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
            if let landmark = cluster.memberAnnotations.first as? DefaultAnnotation {
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
            let textRect = CGRect(x: 40, y: 0, width: size.width, height: size.height)
            text.draw(in: textRect, withAttributes: attributes)
        }
    }
}
