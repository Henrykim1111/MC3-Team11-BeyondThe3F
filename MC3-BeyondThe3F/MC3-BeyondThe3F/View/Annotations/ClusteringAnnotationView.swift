//
//  ClusteringAnnotationView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/21.
//

import SwiftUI
import MapKit

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
        
        self.image = self.addClusterCount(drawRatio(cluster), cluster)
    }
    
    private func drawRatio(_ cluster: MKClusterAnnotation) -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 80, height: 80))
        return renderer.image { ctx in
            UIColor.white.setFill()
            let rectWhite = CGRect(x: 0, y: 10, width: 64, height: 64)
            let roundedWhite = UIBezierPath(roundedRect: rectWhite, cornerRadius: 10)
            roundedWhite.addClip()
            UIRectFill(rectWhite)
            
            let rect = CGRect(x: 5, y: 15, width: 54, height: 54)
            let rounded = UIBezierPath(roundedRect: rect, cornerRadius: 7)
            rounded.addClip()
            if let landmark = cluster.memberAnnotations.first as? MusicAnnotation {
                let img = UIImage(named: "\(landmark.musicData.savedImage ?? "annotaion0")")
                img?.draw(in: rect)
            } else {
                let img = UIImage(named: "annotaion0")
                img?.draw(in: rect)
            }
        }
    }
    
    private func addClusterCount(_ image:UIImage,_ cluster: MKClusterAnnotation) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 80, height: 80))
        return renderer.image { ctx in
            
            let rect = CGRect(x: 0, y: 0, width: 80, height: 80)
            image.draw(in: rect)
            UIColor(Color.custom(.primary)).setFill()
            
            UIBezierPath(ovalIn: CGRect(x: 50, y: 5, width: 24, height: 24)).fill()
            
            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor(Color.custom(.white)),
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
            let text = "\(cluster.memberAnnotations.count)"
            let size = text.size(withAttributes: attributes)
            let textRect = CGRect(x: 57, y: 7, width: size.width, height: size.height)
            text.draw(in: textRect, withAttributes: attributes)
        }
    }
}
