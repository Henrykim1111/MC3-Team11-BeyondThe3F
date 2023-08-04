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
    private var imageLoaded = false

    /// setting the key for clustering annotations
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = clusterID
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        
        guard let musicAnnotation = annotation as? MusicAnnotation else {
            image = UIImage(named: "annotaion0")
            return
        }
        Task {
            do {
                let convertedImage = try await fetchImage(urlString: musicAnnotation.musicData.savedImage ?? "")
                let resizedImage = await resizeImage(img: convertedImage)
                image = resizedImage
            } catch {
                
            }
        }
    }
    
    private func resizeImage(img: UIImage) async -> UIImage{
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
            img.draw(in: rect)
        }
    }
    
    private func fetchImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            return UIImage(named: "annotaion0")!
        }
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
            
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  (200...299).contains(statusCode) else { throw NSError(domain: "fetch error", code: 1004) }
        guard let image = UIImage(data: data) else {
            return UIImage(named: "annotaion0")!
        }
        return image
    }
}

