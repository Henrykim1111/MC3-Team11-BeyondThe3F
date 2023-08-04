//
//  MusicSeachedItemRowComponentView.swift
//  Tune Spot
//
//  Created by Seungui Moon on 2023/08/04.
//

import MusicKit
import SwiftUI

struct MusicSeachedItemRowComponentView: View {
    var item: Song
    var onTabButton: () -> Void
    
    var body: some View {
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
                    .truncationMode(.tail)
                    .lineLimit(1)
                    .padding(.bottom, 4)
                Text(item.artistName)
                    .body2(color: .gray500)
                    .truncationMode(.tail)
                    .lineLimit(1)
            }
            Spacer()
            NavigationLink {
                EditMapPositionView(nextProcess: .forward)
                    .navigationBarBackButtonHidden(true)
                    .simultaneousGesture(TapGesture().onEnded {
                        onTabButton()
                    })
            } label: {
                SFImageComponentView(symbolName: .plus, color: .white, width: 22, height: 22)
            }
        }
    }
}

//struct MusicSeachedItemRowComponentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MusicSeachedItemRowComponentView()
//    }
//}
