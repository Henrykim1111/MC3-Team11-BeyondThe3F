//
//  BucketView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/18.
//

import SwiftUI

struct BucketView: View {
    @State private var searchTerm = ""
    @State private var showSearchView = false
    @State private var showMusicPlayView = false
        
    var body: some View {
        NavigationStack {
            VStack {
                MusicSearchComponentView(searchTerm: $searchTerm, showSearchView: $showSearchView)
                    .padding()
                if showSearchView {
                    MusicSearchView(searchTerm: $searchTerm)
                } else {
                    CarouselView()
                }
                Button {
                    showMusicPlayView = true
                } label: {
                    MusicPlayerComponentView()
                }
            }
            .background(Color.custom(.background))
            .sheet(isPresented: $showMusicPlayView) {
                MusicPlayView()
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

struct BucketView_Previews: PreviewProvider {
    static var previews: some View {
        BucketView()
    }
}
