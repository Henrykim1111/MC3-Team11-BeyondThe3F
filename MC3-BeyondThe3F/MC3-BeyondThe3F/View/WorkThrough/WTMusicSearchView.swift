//
//  WTMusicSearchView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/29.
//

import SwiftUI

struct WTMusicSearchView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("music searh")
                
                NavigationLink {
                    WTMapSearchView()
                } label: {
                    Text("+")
                }
            }
        }
    }
}

struct WTMusicSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WTMusicSearchView()
    }
}
