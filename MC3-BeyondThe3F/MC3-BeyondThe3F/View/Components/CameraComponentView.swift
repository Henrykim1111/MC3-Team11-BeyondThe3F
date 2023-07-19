//
//  CameraComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct CameraComponentView: View {
    var backgroundColor: CustomColor = .gray700
    var foregroundColor: CustomColor = .white
    
    var body: some View {
        HStack{
            Image(systemName: "camera.fill")
            Text("카메라")
        }
        .frame(width: 110, height: 48)
        .background(Color.custom(backgroundColor))
        .foregroundColor(Color.custom(foregroundColor))
        .cornerRadius(8)
    }
}

struct CameraComponentView_Previews: PreviewProvider {
    static var previews: some View {
        CameraComponentView()
    }
}
