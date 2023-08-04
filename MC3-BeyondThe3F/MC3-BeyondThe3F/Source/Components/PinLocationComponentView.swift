//
//  PinLocationComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct PinLocationComponentView: View {
    var color: CustomColor = .gray700
    var body: some View {
        Image("pinLocation")
            .resizable()
            .frame(width: 39.33, height: 59)
            .foregroundColor(Color.custom(color))
    }
    
    struct PinLocationComponentView_Previews: PreviewProvider {
        static var previews: some View {
            PinLocationComponentView()
        }
    }
}
