//
//  MusicAnnotationView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/21.
//

import SwiftUI
import MapKit

/// here posible to customize annotation view
let clusterID = "clustering"

class MusicAnnotationView: MKAnnotationView {

    static let ReuseID = "cultureAnnotation"

    /// setting the key for clustering annotations
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = clusterID
        
        guard let landmark = annotation as? MusicAnnotation else {
            image = UIImage(named: "annotationImage")
            return
        }
        image = resizeImage(imageName: landmark.savedImage)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
    }
    
    private func resizeImage(imageName: String?) -> UIImage{
        guard let imageNameString = imageName else {
            return UIImage(named: "annotationImage")!
        }
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
            let img = UIImage(named: imageNameString)
            img?.draw(in: rect)
        }
    }
}

