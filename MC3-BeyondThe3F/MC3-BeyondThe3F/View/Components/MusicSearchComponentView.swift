//
//  MusicSearchView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/20.
//

import SwiftUI

struct MusicSearchComponentView: View {
    @Binding var searchTerm: String
    @Binding var showSearchView: Bool
    @FocusState private var onSearching : Bool
    
    
    var body: some View {
        HStack(spacing: 0){
            HStack {
                Button {
                    showSearchView = false
                    searchTerm = ""
                    onSearching = false
                } label: {
                    SFImageComponentView(
                        symbolName: showSearchView ? .chevronBack : .magnifyingGlass,
                        color: .white,
                        width: 18,
                        height: 18
                    )
                }

                Spacer()
                    .frame(width: 20)
                TextField("\(onSearching ? "음악을 검색해보세요":"음악을 추가해보세요")", text: $searchTerm)
                    .focused($onSearching)
                    .onChange(of: onSearching) { searchingState in
                        showSearchView = searchingState
                    }
                    
                Spacer()
                if showSearchView {
                    Button {
                        searchTerm = ""
                    } label: {
                        SFImageComponentView(
                            symbolName: .cancel,
                            color: .gray500,
                            width: 16,
                            height: 16)
                    }

                }
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: 350)
            .frame(height: 48)
            .background(Color.custom(.secondaryDark))
            .cornerRadius(4)
            .colorScheme(.dark)
            .accentColor(.white)
            
            Spacer()
            
            // TODO: Navigate to ShazamView
            Image(systemName: "shazam.logo.fill")
                .resizable()
                .scaledToFit()
                .frame(width: CGFloat(29), height: CGFloat(29))
                .foregroundColor(Color.custom(.gray200))
        }
    }
}

private struct MusicSearchCompomponentPreview: View {
    @State private var searchTerm = ""
    @State private var showSearchView = false
    var body: some View {
        MusicSearchComponentView(
            searchTerm: $searchTerm,
            showSearchView: $showSearchView
        )
    }
}

struct MusicSearchComponentView_Previews: PreviewProvider {
    static var previews: some View {
        MusicSearchCompomponentPreview()
    }
}
