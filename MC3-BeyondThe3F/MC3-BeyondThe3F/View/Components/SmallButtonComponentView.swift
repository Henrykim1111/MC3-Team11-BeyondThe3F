//
//  SmallButtonComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/20.
//

import SwiftUI

struct SmallButtonComponentView: View {
    var backgroundColor: CustomColor = .secondaryDark
    var foregroundColor: CustomColor = .white
    var sfImageName: SFImageType = .camera
    var name = "카메라"
    
    var body: some View {
        HStack{
            SFImageComponentView(symbolName: sfImageName,color: .white)
            Text(name)
                .body2(color: foregroundColor)
        }
        .frame(maxWidth: 110)
        .frame(height: 48)
        .background(Color.custom(backgroundColor))
        .cornerRadius(8)
    }
}

struct SmallButtonComponentView_Previews: PreviewProvider {
    static var previews: some View {
        SmallButtonComponentView()
    }
}
