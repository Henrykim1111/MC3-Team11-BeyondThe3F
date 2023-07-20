//
//  SaveAtThisLocationButtonComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct SaveAtThisLocationButtonComponentView: View {
    var body: some View {
        Text("이 위치에 기록")
            .foregroundColor(.white)
            .frame(width: 350, height: 48)
            .background(Color.custom(.primary))
            .cornerRadius(4)
    }
}

struct SaveAtThisLocationButtonComponentView_Previews: PreviewProvider {
    static var previews: some View {
        SaveAtThisLocationButtonComponentView()
    }
}
