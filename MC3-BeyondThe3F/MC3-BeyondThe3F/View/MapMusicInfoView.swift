//
//  MapMusicInfoView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/24.
//

import SwiftUI

struct MapMusicInfoView: View {
    @Binding var musicList: [MusicItem]
    @Binding var centerPlaceDescription: String
    
    @State private var draggedYOffset: CGFloat = 500.0
    @State private var accumulatedYOffset: CGFloat = 500.0
    @State private var maxHeight: CGFloat = 500.0
    @State private var minHeight: CGFloat = 100.0
    @State private var showActionSheet = false
    @State private var showAddMusicView = false
    
    @State private var selectedMusic: MusicItem?
    
    let musicPlayer = MusicPlayer.shared
    let musicItemUpdateViewModel = MusicItemUpdateViewModel.shared
    let musicItemDataModel = MusicItemDataModel.shared
    var persistentContainer = PersistenceController.shared.container
    

    var body: some View {
        GeometryReader { geo in
            VStack{
                VStack{
                    HStack {
                        Spacer()
                        Rectangle()
                            .foregroundColor(Color.custom(.white))
                            .frame(width: 40, height: 5)
                            .opacity(0.4)
                            .cornerRadius(3)
                        Spacer()
                    }
                    HStack {
                        if musicList.isEmpty {
                            ProgressView()
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                                .foregroundColor(Color.custom(.white))
                                .padding(.trailing, 15)
                        } else {
                            AsyncImage(url: URL(string: musicList.first?.savedImage ?? "")) { image in
                                image
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                            } placeholder: {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(Color.custom(.secondaryDark))
                                        .cornerRadius(6)
                                    ProgressView()
                                }
                            }
                            .frame(width: 60, height: 60)
                                .cornerRadius(8)
                                .padding(.trailing, 15)
                        }

                        VStack(alignment: .leading){
                            Text(centerPlaceDescription)
                                .title2(color: .white)
                                .padding(.bottom, 2)
                                .lineLimit(1)
                            Text("\(musicList.count)곡 수집")
                                .body1(color: .white)
                        }
                        Spacer()
                    }
                    .padding(.bottom,15)
                    
                    HStack {
                        Button {
                            // TODO: reset PlayList
                            if !musicList.isEmpty {
                                for musicItem in musicList {
                                    musicPlayer.insertMusicAndPlay(musicId: musicItem.musicId ?? "", songName: musicItem.songName ?? "", artistName: musicItem.artistName ?? "")
                                }
                                
                            }
                        } label: {
                            MidButtonComponent()
                        }
                        Spacer()
                        Button {
                            // TODO: reset shuffle playlist
                            if !musicList.isEmpty {
                                var tempMusicList = musicList
                                tempMusicList.shuffle()
                                for musicItem in tempMusicList {
                                    musicPlayer.insertMusicAndPlay(musicId: musicItem.musicId ?? "", songName: musicItem.songName ?? "", artistName: musicItem.artistName ?? "")
                                }
                            }
                        } label: {
                            MidButtonComponent(sfImageName: .shuffle, name: .임의재생)
                        }
                    }
                }
                .padding()
                
                Divider()
                    .overlay(Color.custom(.white))
                ScrollView {
                    LazyVStack{
                        ForEach(musicList) { musicItem in
                            MusicListRowView(
                                imageName: musicItem.savedImage ?? "annotation0",
                                songName: musicItem.songName ?? "",
                                artistName: musicItem.artistName ?? "",
                                musicListRowType: .saved,
                                buttonEllipsisAction: {
                                    showActionSheet = true
                                    selectedMusic = musicItem
                                }
                            )
                            .background(Color.custom(.background))
                            .onTapGesture {
                                musicPlayer.insertMusicAndPlay(musicId: musicItem.musicId ?? "", songName: musicItem.songName ?? "", artistName: musicItem.artistName ?? "")
                            }
                        }
                    }
                }
                .padding()
                .frame(minHeight: 300)
            }
            .frame(idealWidth: geo.size.width)
            .frame(height: geo.size.height)
            .background(Color.custom(.background))
            .presentationDragIndicator(.visible)
            .offset(y: draggedYOffset)
            .gesture(drag)
            .onAppear {
                maxHeight = geo.size.height - 120
                minHeight = 30
                draggedYOffset = geo.size.height - 120
                accumulatedYOffset = geo.size.height - 120
            }
            .confirmationDialog("타이틀", isPresented: $showActionSheet) {
                Button("편집", role: .none) {
                    showActionSheet = false
                    guard let musicItem = selectedMusic else {
                        return
                    }
                    musicItemUpdateViewModel.musicItemshared.savedImage = musicItem.savedImage ?? ""
                    musicItemUpdateViewModel.musicItemshared.songName = musicItem.songName ?? ""
                    musicItemUpdateViewModel.musicItemshared.musicId = musicItem.musicId ?? ""
                    musicItemUpdateViewModel.musicItemshared.artistName = musicItem.artistName ?? ""
                    musicItemUpdateViewModel.musicItemshared.locationInfo = musicItem.locationInfo ?? ""
                    musicItemUpdateViewModel.musicItemshared.longitude = musicItem.longitude
                    musicItemUpdateViewModel.musicItemshared.latitude = musicItem.latitude
                    musicItemUpdateViewModel.musicItemshared.generatedDate = musicItem.generatedDate ?? Date()
                    musicItemUpdateViewModel.musicItemshared.playedCount = 0
                    musicItemUpdateViewModel.isEditing = true
                    musicItemUpdateViewModel.isUpdate = true
                }
                Button("제거", role: .destructive) {
                    // TODO: Delete Item in CoreData
                    guard let musicItem = selectedMusic else {
                        return
                    }
                    musicItemDataModel.deleteMusicItemWith(musicId: musicItem.musicId ?? "", locationInfo: musicItem.locationInfo ?? "")
                }
                Button("취소", role: .cancel) {}
            }
            .sheet(isPresented: $showAddMusicView) {
                AddMusicView()
                // TODO: send default MusicData to AddMusicView for Editing
            }
        }
    }
    var drag: some Gesture {
        DragGesture()
            .onChanged { gesture in
                let caculatedValue = accumulatedYOffset + gesture.translation.height
                if caculatedValue > maxHeight {
                    draggedYOffset = maxHeight
                } else if caculatedValue < minHeight {
                    draggedYOffset = minHeight
                } else {
                    draggedYOffset = caculatedValue
                }
            }
            .onEnded { gesture in
                let caculatedValue = accumulatedYOffset + gesture.translation.height
                
                withAnimation(.easeInOut(duration: 0.2)) {
                    if caculatedValue > maxHeight {
                        accumulatedYOffset = maxHeight
                    } else if caculatedValue < minHeight {
                        accumulatedYOffset = minHeight
                    } else {
                        if caculatedValue > (maxHeight + minHeight) / 2 + 100 {
                            accumulatedYOffset = maxHeight
                        } else if caculatedValue > (maxHeight + minHeight) / 2 - 100 {
                            accumulatedYOffset = (maxHeight + minHeight) / 2
                        } else {
                            accumulatedYOffset = minHeight
                        }
                        draggedYOffset = accumulatedYOffset
                    }
                }
            }
    }
}

//struct MapMusicInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapMusicInfoView()
//    }
//}
