//
//  TypoModifier.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/18.
//

import SwiftUI

struct TitleModifier: ViewModifier {
    var color: CustomColor = .white
    
    func body(content: Content) -> some View {
        content
            .fontWeight(.heavy)
            .font(.system(size: 32))
            .foregroundColor(Color.custom(color))
    }
}
