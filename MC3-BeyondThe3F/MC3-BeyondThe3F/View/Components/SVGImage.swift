//
//  SVGImage.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/29.
//

import UIKit

struct SVGImage: UIViewRepresentable {

    var svgName: String

    func makeUIView(context: Context) -> SVGView {
        let svgView = SVGView()
        svgView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)   // otherwise the background is black
        svgView.fileName = self.svgName
        svgView.contentMode = .scaleToFill
        return svgView
    }

    func updateUIView(_ uiView: SVGView, context: Context) {

    }

}
