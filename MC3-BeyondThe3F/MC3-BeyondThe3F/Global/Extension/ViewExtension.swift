//
//  ViewExtension.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/18.
//

import SwiftUI

extension View {
    func title(color: CustomColor = .primary) -> some View {
        modifier(TitleModifier(color: color))
    }
}

// MARK: - 사용방법
//Text("title text")
//    .title()
//Text("title text")
//    .title(color: .secondary)

