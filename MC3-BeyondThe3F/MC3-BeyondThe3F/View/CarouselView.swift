//
//  Carousel.swift
//  MC3-BeyondThe3F
//
//  Created by Hyungmin Kim on 2023/07/25.
//

import SwiftUI

struct CarouselView: View {
    typealias PageIndex = Int
    
    let pageCount = 5
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
// VStack {
            HStack(spacing: spacing) {
                ForEach(0..<carouselList.count, id: \.self) { pageIndex in
                    CarouselCardItem(
                        carouselItemData: carouselList[pageIndex],
                        pageWidth: pageWidth
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
                        
                        currentIndex = max(min(currentIndex + increment, pageCount - 1), 0)
                    }
            )
// }
            .onAppear{
                carouselList = mainDataModel.getData
            }
        }
    }
}

struct CarouselCardItem: View {
    var carouselItemData: MainVO
    var pageWidth: CGFloat
    
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
            }
            .padding(16)
            
            Divider()
                .background(Color.custom(.gray500))
            
            ScrollView {
                ForEach(carouselItemData.musicList, id: \.self) { item in
                    HStack(spacing: 0) {
                        Image(item.savedImage ?? "annotaion0")
                            .resizable()
                            .frame(width:60, height: 60)
                            .cornerRadius(8)
                        VStack(alignment: .leading, spacing: 0) {
                            Text("\(item.songName ?? "")")
                                .body1(color: .white)
                                .padding(.bottom, 5)
                            Text("\(item.artistName ?? "")")
                                .body2(color: .gray500)
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                    .padding(.bottom, 10)
                }

                
/*
// 곡 리스트 개수에 따라 카드뷰 크기 조절 테스트용..
                HStack(spacing: 0) {
                        Image(carouselItemData.musicList[0].savedImage ?? "annotaion0")
                            .resizable()
                            .frame(width:60, height: 60)
                            .cornerRadius(8)
                        VStack(alignment: .leading, spacing: 0) {
                            Text("\(carouselItemData.musicList[0].songName ?? "")")
                                .body1(color: .white)
                                .padding(.bottom, 5)
                            Text("\(carouselItemData.musicList[0].artistName ?? "")")
                                .body2(color: .gray500)
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                    .padding(.bottom, 10)
*/ 
                
            }
// fixedSize 적용 시 카드 뷰 높이가 달라지는 현상 발생.. 대체 와이..
//            .fixedSize(horizontal: false, vertical: true)
            .padding(16)
        }
        .background(Color.custom(.secondaryDark))
        .cornerRadius(8)
        .frame(
            width: pageWidth
        )
    }
}




struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
    }
}

