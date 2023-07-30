//
//  WTMapSearchView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/29.
//

import SwiftUI

struct WTMapSearchView: View {
    var body: some View {
        VStack {
            Text("map search view")
            NavigationLink {
                WTEditMapPositionView()
            } label: {
                Text("이 위치에 저장")
            }
        }
    }
}

struct WTMapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WTMapSearchView()
    }
}
