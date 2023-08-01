//
//  Carousel.swift
//  MC3-BeyondThe3F
//
//  Created by Hyungmin Kim on 2023/07/25.
//

import SwiftUI

struct CarouselView: View {
    
    let maxPageCount = 5
    let visibleEdgeSpace: CGFloat = 20
    let spacing: CGFloat = 16
    let mainDataModel = MainDataModel.shared
    
    @State private var carouselList: [MainVO] = []
    
    @GestureState var dragOffset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            let baseOffset: CGFloat = spacing + visibleEdgeSpace
            let pageWidth: CGFloat = proxy.size.width - (visibleEdgeSpace + spacing) * 2
            let offsetX: CGFloat = baseOffset + CGFloat(currentIndex) * -pageWidth + CGFloat(currentIndex) * -spacing + dragOffset

            HStack(alignment: .top, spacing: spacing) {
                ForEach(0 ..< min(carouselList.count, maxPageCount), id: \.self) { pageIndex in
                    CarouselCardItem(
                        carouselItemData: carouselList[pageIndex],
                        pageWidth: pageWidth,
                        pageIndex: pageIndex
                    )
                }
                .contentShape(Rectangle())
            }
            .offset(x: offsetX)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, out, _ in
                        out = value.translation.width
                    }
                    .onEnded { value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / pageWidth
                        let increment = Int(progress.rounded())
                        
                        currentIndex = max(min(currentIndex + increment, carouselList.count - 1), 0)
                    }
            )
            .onAppear{
                carouselList = mainDataModel.getData
            }
            .onChange(of: MusicItemDataModel.shared.musicList) { _ in
                carouselList = mainDataModel.getData
            }
        }
    }
}

struct CarouselCardItem: View {
    
    var carouselItemData: MainVO
    var pageWidth: CGFloat
    var pageIndex: Int
    
    let musicPlayer = MusicPlayer.shared
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack (alignment: .leading, spacing: 0) {
                    Text(carouselItemData.locationInfo)
                        .title2(color: .white)
                        .padding(.bottom, 5)
                    Text("노래 \(carouselItemData.musicList.count)곡")
                        .body1(color: .gray500)
                }
                Spacer()
                ButtonPlayComponentView()
                    .onTapGesture {
                        MusicPlayer.shared.playlist = MainDataModel.shared.getData[pageIndex].musicList.map{$0.musicItemVO}
                    }
            }
            .padding(16)
            
            Divider()
                .background(Color.custom(.gray500))
            
            List{
                ForEach(carouselItemData.musicList, id: \.self) { item in
                    Button {
                        musicPlayer.insertMusicAndPlay(musicItem: item.musicItemVO)
                    } label: {
                        HStack(spacing: 0) {
                            AsyncImage(url: URL(string: item.savedImage ?? "")) { image in
                                image
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                            } placeholder: {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(Color.custom(.gray400))
                                        .cornerRadius(6)
                                    ProgressView()
                                }
                            }
                            .frame(width: 60, height: 60)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text("\(item.songName ?? "")")
                                    .body1(color: .white)
                                    .padding(.bottom, 5)
                                    .lineLimit(2)
                                Text("\(item.artistName ?? "")")
                                    .body2(color: .gray500)
                                    .lineLimit(1)
                            }
                            .padding(.horizontal)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                }
                .listRowBackground(Color.custom(.secondaryDark))
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
            .frame(maxHeight: CGFloat(carouselItemData.musicList.count) * 84)
            .scrollContentBackground(.hidden)
        }
        .background(Color.custom(.secondaryDark))
        .cornerRadius(8)
        .frame(
            width: pageWidth
        )
        .onAppear {
            
        }
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
    }
}
