//
//  ButtonPlayComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct ButtonPlayComponentView: View {
    var body: some View {
        VStack {
            SFImageComponentView(
                symbolName: .play,
                color: .white,
                width: 18,
                height: 24)
                .offset(x: 1, y: 0)
        }
        .frame(width: 48, height: 48)
        .background(Color.custom(.primary))
        .cornerRadius(24)
    }
        
    
    struct ButtonPlayComponentView_Previews: PreviewProvider {
        static var previews: some View {
            ButtonPlayComponentView()
        }
    }
}
