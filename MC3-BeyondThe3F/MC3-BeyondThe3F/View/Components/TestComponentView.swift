//
//  TestComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct TestComponentView: View {
    var body: some View {
        VStack{
            CameraButtonComponentView()
            CameraButtonComponentView(backgroundColor: .primary, foregroundColor: .gray200)
            Button {
                
            } label: {
                ButtonPlayComponentView()
            }
            ButtonPlayComponentView()

            
        }
    }
}

struct TestComponentView_Previews: PreviewProvider {
    static var previews: some View {
        TestComponentView()
    }
}
