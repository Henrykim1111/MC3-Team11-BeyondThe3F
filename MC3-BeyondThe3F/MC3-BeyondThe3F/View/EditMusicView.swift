//
//  EditMusicView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/30.
//

import MusicKit
import SwiftUI

struct EditMusicView: View {
    var nextProcess: NextProcess = .backward
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var musicUpdateViewModel = MusicItemUpdateViewModel.shared
    @StateObject private var musicSearchViewModel = MusicSearchViewModel()
    private let musicItemDataModel = MusicItemDataModel.shared
    @State private var searchTerm = ""
    @State private var showSearchView = true
    
    var body: some View {
        
        VStack(alignment: .leading) {
            MusicSearchComponentView(searchTerm: $searchTerm, showSearchView: $showSearchView)
            ScrollView {
                LazyVStack {
                    Spacer()
                        .frame(width: 390)
                   
                    ForEach(musicSearchViewModel.searchSongs, id: \.self) { item in
                        Button {
                            musicSearchViewModel.addMusicHistory(musicId: item.id.rawValue, songName: item.title)
                        } label: {
                            HStack {
                                if let existingArtwork = item.artwork {
                                    ArtworkImage(existingArtwork, width: 60)
                                        .cornerRadius(8)
                                }
                                Spacer()
                                    .frame(width: 16)
                                VStack(alignment: .leading){
                                    Text(item.title)
                                        .body1(color: .white)
                                        .padding(.bottom, 4)
                                    Text(item.artistName)
                                        .body2(color: .gray500)
                                }
                                Spacer()
                                Button {
                                    Task{
                                        
                                        guard let musicItems = await musicItemDataModel.getInfoByMusicId(item.id.rawValue) else {
                                            return
                                        }
                                        guard let musicItem = musicItems.items.first else {
                                            return
                                        }
                                        musicUpdateViewModel.musicItemshared.musicId = musicItem.id.rawValue
                                        musicUpdateViewModel.musicItemshared.songName = musicItem.title
                                        musicUpdateViewModel.musicItemshared.artistName = musicItem.artistName
                                        if let imageURL = musicItem.artwork?.url(width: 500, height: 500) {
                                            do {
                                                musicUpdateViewModel.musicItemshared.savedImage = try String(contentsOf: imageURL)
                                            } catch {
                                                
                                            }
                                        } else {
                                            musicUpdateViewModel.musicItemshared.savedImage = nil
                                        }
                                        
                                        dismiss()
                                    }
                                } label: {
                                    SFImageComponentView(symbolName: .plus, color: .white, width: 22, height: 22)
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.custom(.background))
        .onChange(of: searchTerm, perform: musicSearchViewModel.requestUpdateSearchResults)
    }
}

struct EditMusicView_Previews: PreviewProvider {
    static var previews: some View {
        EditMusicView()
    }
}
