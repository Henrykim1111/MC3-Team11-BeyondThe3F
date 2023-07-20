//
//  MicComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct MicComponentView: View {
    var color: CustomColor = .white
    var body: some View {
        Image(systemName: "mic.fill")
            .frame(width: 24, height: 24)
            .foregroundColor(Color.custom(color))
    }
}

struct MicComponentView_Previews: PreviewProvider {
    static var previews: some View {
        MicComponentView()
    }
}
