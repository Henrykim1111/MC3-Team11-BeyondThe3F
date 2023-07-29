//
//  WTEditMusicView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/29.
//

import SwiftUI

struct WTEditMusicView: View {
    var body: some View {
        VStack {
            Text("map edit position")
            NavigationLink {
                MainTabView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                Text("저장")
            }
        }
    }
}

struct WTEditMusicView_Previews: PreviewProvider {
    static var previews: some View {
        WTEditMusicView()
    }
}
