//
//  PauseComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/20.
//

import SwiftUI

struct PauseComponentView: View {
    var color: CustomColor = .white
    var body: some View {
        Image(systemName: "pause.fill")
           
            .frame(width: 29, height: 32)
            .foregroundColor(Color.custom(color))
    }
    }


struct PauseComponentView_Previews: PreviewProvider {
    static var previews: some View {
        PauseComponentView()
    }
}
