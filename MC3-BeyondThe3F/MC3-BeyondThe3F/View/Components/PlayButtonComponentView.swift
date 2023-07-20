//
//  PlayButtonComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct PlayButtonComponentView: View {
    var color: CustomColor = .white
    var body: some View {
        Image(systemName: "play.fill")
            
            .frame(width: 24, height: 24)
            .foregroundColor(Color.custom(color))
    }
}

struct PlayButtonComponentView_Previews: PreviewProvider {
    static var previews: some View {
        PlayButtonComponentView()
    }
}

//폰트, 깃허브에서 오류 수정한 것 풀 받기, CancelComponentView 안보임

