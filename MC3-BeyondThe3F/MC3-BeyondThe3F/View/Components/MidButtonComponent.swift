//
//  MidButtonComponent.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/20.
//

import SwiftUI

struct MidButtonComponent: View {
    enum MidType: String {
        case 카메라
        case 재생
    }
    
    var backgroundColor: CustomColor = .primary
    var foregroundColor: CustomColor = .white
    var sfImageName: SFImageType = .play
    var name : MidType = .재생
    
    var body: some View {
        HStack {
            SFImageComponentView(symbolName: sfImageName, color: foregroundColor)
            Text(name.rawValue)
                .body1(color: foregroundColor)
        }
        .frame(maxWidth: 167)
        .frame(height: 48)
        .background(Color.custom(backgroundColor))
        .cornerRadius(4)
    }
}

struct MidButtonComponent_Previews: PreviewProvider {
    static var previews: some View {
        MidButtonComponent()
    }
}
