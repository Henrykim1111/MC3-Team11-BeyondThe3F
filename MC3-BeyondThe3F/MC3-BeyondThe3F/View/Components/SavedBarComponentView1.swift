//
//  SavedBarComponentView1.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct SavedBarComponentView1: View {
    var body: some View {
        Text("저장되었습니다!")
            .foregroundColor(.black)
            .frame(width: 350, height: 48)
            .background(Color.custom(.white))
            .cornerRadius(4)
    }
}

struct SavedBarComponentView1_Previews: PreviewProvider {
    static var previews: some View {
        SavedBarComponentView1()
    }
}
