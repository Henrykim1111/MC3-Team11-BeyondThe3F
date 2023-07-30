//
//  WTEditDateView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/29.
//

import SwiftUI

struct WTEditDateView: View {
    var body: some View {
        VStack {
            Text("map edit position")
            NavigationLink {
                WTEditMusicView()
            } label: {
                Text("이 날짜로 저장")
            }
        }
    }
}

struct WTEditDateView_Previews: PreviewProvider {
    static var previews: some View {
        WTEditDateView()
    }
}
