//
//  ViewExtension.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/18.
//

import SwiftUI

extension View {
    
    func title(color: Color = .gray100) -> some View {
        modifier(
            TitleModifier()
        )
    }
}
