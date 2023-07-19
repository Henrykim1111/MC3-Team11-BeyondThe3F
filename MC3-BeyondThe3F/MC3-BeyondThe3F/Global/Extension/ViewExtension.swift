//
//  ViewExtension.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/18.
//

import SwiftUI

extension View {
    func title(color: CustomColor = .gray700) -> some View {
        modifier(TitleModifier(color: color))
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
}

// MARK: - 사용방법
//Text("title text")
//    .title()
//Text("title text")
//    .title(color: .secondary)

