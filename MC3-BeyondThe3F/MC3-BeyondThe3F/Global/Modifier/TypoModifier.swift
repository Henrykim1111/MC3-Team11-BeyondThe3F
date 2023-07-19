//
//  TypoModifier.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/18.
//

import SwiftUI

struct Title1Modifier: ViewModifier {
    var color: CustomColor = .gray700
    
    func body(content: Content) -> some View {
        content
            .fontWeight(.heavy)
            .font(.system(size: 32))
            .foregroundColor(Color.custom(color))
    }
}

struct Title2Modifier: ViewModifier {
    var color: CustomColor = .gray700
    
    func body(content: Content) -> some View {
        content
            .fontWeight(.medium)
            .font(.system(size: 24))
            .foregroundColor(Color.custom(color))
    }
}

struct HeadlineModifier: ViewModifier {
    var color: CustomColor = .gray700
    
    func body(content: Content) -> some View {
        content
            .fontWeight(.medium)
            .font(.system(size: 20))
            .foregroundColor(Color.custom(color))
    }
}

struct Body1Modifier: ViewModifier {
    var color: CustomColor = .gray700
    
    func body(content: Content) -> some View {
        content
            .fontWeight(.regular)
            .font(.system(size: 18))
            .foregroundColor(Color.custom(color))
    }
}

struct Body2Modifier: ViewModifier {
    var color: CustomColor = .gray700
    
    func body(content: Content) -> some View {
        content
            .fontWeight(.regular)
            .font(.system(size: 15))
            .foregroundColor(Color.custom(color))
    }
}

struct CaptionModifier: ViewModifier {
    var color: CustomColor = .gray700
    
    func body(content: Content) -> some View {
        content
            .fontWeight(.regular)
            .font(.system(size: 12))
            .foregroundColor(Color.custom(color))
    }
}
