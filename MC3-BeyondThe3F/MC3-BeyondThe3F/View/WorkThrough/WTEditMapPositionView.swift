//
//  WTEditMapPositionView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/29.
//

import SwiftUI

struct WTEditMapPositionView: View {
    var body: some View {
        VStack {
            Text("map edit position")
            NavigationLink {
                WTEditDateView()
            } label: {
                Text("이 위치에 저장")
            }
        }
    }
}

struct WTEditMapPositionView_Previews: PreviewProvider {
    static var previews: some View {
        WTEditMapPositionView()
    }
}
