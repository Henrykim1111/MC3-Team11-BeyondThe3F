//
//  ViewExtension.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/18.
//

import SwiftUI

extension View {
    func title1(color: CustomColor = .gray700) -> some View {
        modifier(Title1Modifier(color: color))
    }
    func title2(color: CustomColor = .gray700) -> some View {
        modifier(Title2Modifier(color: color))
    }
    func headline(color: CustomColor = .gray700) -> some View {
        modifier(HeadlineModifier(color: color))
    }
    func body1(color: CustomColor = .gray700) -> some View {
        modifier(Body1Modifier(color: color))
    }
    func body2(color: CustomColor = .gray700) -> some View {
        modifier(Body2Modifier(color: color))
    }
    func caption(color: CustomColor = .gray700) -> some View {
        modifier(CaptionModifier(color: color))
    }
    
    func endTextEditing(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


