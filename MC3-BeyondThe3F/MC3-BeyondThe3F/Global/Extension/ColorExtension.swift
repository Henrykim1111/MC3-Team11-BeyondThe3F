//
//  ColorExtension.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/18.
//

import SwiftUI

extension Color {
    
    /// Color Pallete
    static let white = Color(hex: "ffffff")
    static let gray100 = Color(hex: "CECECF")
    static let gray200 = Color(hex: "9C9C9F")
    static let gray300 = Color(hex: "6B6B70")
    static let gray400 = Color(hex: "393940")
    static let gray500 = Color(hex: "080810")
    static let gray600 = Color(hex: "080816")
    static let gray700 = Color(hex: "05050A")
    
    /// primary
    static let primary = Color(hex: "7F6AFF")
    static let primaryLight = Color(hex: "B3A7FF")
    
    /// secondary
    static let secondary = Color(hex: "2C2C5A")
    
    
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
}

