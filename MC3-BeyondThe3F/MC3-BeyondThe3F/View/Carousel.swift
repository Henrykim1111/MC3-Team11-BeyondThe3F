//
//  Carousel.swift
//  MC3-BeyondThe3F
//
//  Created by Hyungmin Kim on 2023/07/25.
//

import SwiftUI

struct Carousel: View {
    typealias PageIndex = Int
    
    let pageCount = 5
    let visibleEdgeSpace: CGFloat = 20
    let spacing: CGFloat = 16
    
    let mainDataModel = MainDataModel.shared
    
    @GestureState var dragOffset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            let baseOffset: CGFloat = spacing + visibleEdgeSpace
            let pageWidth: CGFloat = proxy.size.width - (visibleEdgeSpace + spacing) * 2
            let offsetX: CGFloat = baseOffset + CGFloat(currentIndex) * -pageWidth + CGFloat(currentIndex) * -spacing + dragOffset
            VStack {
                Spacer()
                HStack(spacing: spacing) {
                    ForEach(0..<pageCount, id: \.self) { pageIndex in
                        VStack {
                            HStack {
                                VStack (alignment: .leading) {
                                    Text("Location")
                                        .font(.title)
                                    Text("Song count")
                                    // "\(MainVO.musicList.count)"
                                        .font(.title3)
                                }
                                Spacer()
                                ButtonPlayComponentView()
                            }
                            .padding()
                            
                            Divider()
                            
                            ScrollView {
                                HStack {
                                    Rectangle()
                                        .frame(width:60, height: 60)
                                        .cornerRadius(8)
                                    VStack(alignment: .leading) {
                                        Text("\(mainDataModel.getData[0].musicList[0].musicId ?? "")")
                                        //
                                        // "\(MainVO.musicList[0].songName)"
                                        Text("293 studio")
                                        // "\(MainVO.musicList.artistName)"
                                    }
                                    .padding(.horizontal)
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                        .frame(
                            width: pageWidth,
                            height: proxy.size.height
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
            }.onAppear{
                mainDataModel.getData
//                .forEach{
//                    $0.locationInfo
//                    $0.musicList.count
//
//                    $0.musicList.forEach{
//                        $0.musicId
//                        $0.locationInfo
//                    }
//                }
            }
        }
    }
}


struct Carousel_Previews: PreviewProvider {
    static var previews: some View {
        Carousel()
    }
}

