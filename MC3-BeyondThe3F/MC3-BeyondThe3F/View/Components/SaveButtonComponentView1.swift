//
//  SaveButtonComponentView1.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct SaveButtonComponentView1: View {
    var body: some View {
        Text("저장")
            .foregroundColor(.white)
            .frame(width: 350, height: 48)
            .background(Color.custom(.primary))
            .cornerRadius(4)
            
    }
}

struct SaveButtonComponentView1_Previews: PreviewProvider {
    static var previews: some View {
        SaveButtonComponentView1()
    }
}
