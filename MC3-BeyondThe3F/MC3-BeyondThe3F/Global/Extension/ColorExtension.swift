//
//  ColorExtension.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/18.
//

import SwiftUI

extension Color {
    /// function: hex to color
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
    
    static func custom(_ color: CustomColor) -> Color {
        switch color{
        case .white:
            return Color(hex: "ffffff")
        case .gray100:
            return Color(hex: "CECECF")
        case .gray200:
            return Color(hex: "9C9C9F")
        case .gray300:
            return Color(hex: "6B6B70")
        case .gray400:
            return Color(hex: "393940")
        case .gray500:
            return Color(hex: "080810")
        case .gray600:
            return Color(hex: "080816")
        case .gray700:
            return Color(hex: "05050A")
        case .primary:
            return Color(hex: "7F6AFF")
        case .primaryLight:
            return Color(hex: "B3A7FF")
        case .secondary:
            return Color(hex: "2C2C5A")
        }
    }
}

enum CustomColor {
    case white
    case gray100
    case gray200
    case gray300
    case gray400
    case gray500
    case gray600
    case gray700
    
    case primary
    case primaryLight
    
    case secondary
}

