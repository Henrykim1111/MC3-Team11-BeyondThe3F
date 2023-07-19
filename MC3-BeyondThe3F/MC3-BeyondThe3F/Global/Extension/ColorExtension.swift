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
            return Color(hex: "F6F6F6")
        case .gray200:
            return Color(hex: "ECECEC")
        case .gray300:
            return Color(hex: "DFDFDF")
        case .gray400:
            return Color(hex: "C2C2C2")
        case .gray500:
            return Color(hex: "979797")
        case .gray600:
            return Color(hex: "565656")
        case .gray700:
            return Color(hex: "2D2D2D")
        case .primary:
            return Color(hex: "7F6AFF")
        case .secondary:
            return Color(hex: "60618A")
        case .secondaryDark:
            return Color(hex: "262545")
        
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
    
    case secondary
    case secondaryDark
}

