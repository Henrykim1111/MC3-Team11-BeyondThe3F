//
//  TextComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/19.
//

import SwiftUI

struct TextComponentView: View {
    var body: some View {
        HStack{
            Spacer()
            Text("저장")
                .body1(color: .white)
            Spacer()
        }
        .frame(height: 48)
        .background(Color.custom(.primary))
        .cornerRadius(8)
    }
}

struct TextComponentView_Previews: PreviewProvider {
    static var previews: some View {
        TextComponentView()
    }
}
