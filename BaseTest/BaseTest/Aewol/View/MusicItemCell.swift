//
//  MusicItemCell.swift
//  BaseTest
//
//  Created by 이연정 on 2023/07/20.
//

import MusicKit
import SwiftUI

/// `MusicItemCell` is a view to use in a SwiftUI `List` to represent a `MusicItem`.
struct MusicItemCell: View {
    
    // MARK: - Properties
    
    let artwork: Artwork?
    let title: String
    let subtitle: String
    
    // MARK: - View
    
    var body: some View {
        HStack {
            if let existingArtwork = artwork {
            // song은 MusicKit 프레임워크에서 오는 Song 클래스의 인스턴스
            // artwork는 노래와 관련된 아크워크(앨범표지)를 나타내는 Song 클래스의 속성
            // song.artwork가 nil이 아닌 경우 해당 값은 안전하게 언래핑되어 existingArtwork 상수에 할당
            // if let existingArtwork = song.artwork 가 실행될 때 코드는 노래에 사용할 수 있는 아트워크가 있는지 확인
                VStack {
                    Spacer()
                    ArtworkImage(existingArtwork, width: 56)
                    // 노래의 아트워크를 표시하기 위한 커스텀 뷰로, 'song.artwork'에서 아트워크를 가져와 표시
                        .cornerRadius(6)
                    Spacer()
                }
            }
            VStack(alignment: .leading) {
                Text(title)    // 노래의 제목을 표시
                    .lineLimit(1)
                    .foregroundColor(.primary)
                if !subtitle.isEmpty {    // 노래의 ID를 표시
                    Text(subtitle)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                        .padding(.top, -4.0)
                }
            }
        }
        
//        HStack {
//            if let existingArtwork = song.artwork {
//                VStack {
//                    Spacer()
//                    ArtworkImage(existingArtwork, width: 56)
//                        .cornerRadius(6)
//                    Spacer()
//                }
//            }
//            VStack(alignment: .leading) {
//                Text(song.title)
//                    .lineLimit(1)
//                    .foregroundColor(.primary)
//                Text("\(song.id.rawValue)")
//            }
//        }
    }
}
