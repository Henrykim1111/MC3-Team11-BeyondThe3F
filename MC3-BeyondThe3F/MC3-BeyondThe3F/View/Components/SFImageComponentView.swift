//
//  SFImageComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/20.
//

import SwiftUI
enum SFImageType: String {
    case play
    case shuffle
    case chevronFront
    case chevronBack
    case magnifyingGlass
    case mic
    case gearShape
    case scope
    case tray
    case map
    case cancel
    case forward
    case list
    case ellipsis
    case plus
    case icloud
    case camera
    case photo
    case pause
    case shazam
    
    var name: String {
        switch self {
        case .play:
            return "play.fill"
        case .shuffle:
            return "shuffle"
        case .chevronFront:
            return "chevron.forward"
        case .chevronBack:
            return "chevron.backward"
        case .magnifyingGlass:
            return "magnifyingglass"
        case .mic:
            return "mic.fill"
        case .gearShape:
            return "gearshape.fill"
        case .scope:
            return "scope"
        case .tray:
            return "tray.full.fill"
        case .map:
            return "map.fill"
        case .cancel:
            return "xmark"
        case .forward:
            return "forward.fill"
        case .list:
            return "list.bullet"
        case .ellipsis:
            return "ellipsis"
        case .plus:
            return "plus"
        case .icloud:
            return "icloud.and.arrow.down.fill"
        case .camera:
            return "camera.fill"
        case .photo:
            return "photo"
        case .pause:
            return "pause.fill"
        case .shazam:
            return "shazam.logo.fill"
        }
    }
}

struct SFImageComponentView: View {
    let symbolName: SFImageType
    var color: CustomColor = .gray700
    var width = 24
    var height = 24
    
    var body: some View {
        Image(systemName: symbolName.name)
            .resizable()
            .scaledToFit()
            .frame(width: CGFloat(width), height: CGFloat(height))
            .foregroundColor(Color.custom(color))
    }
}

struct SFImageComponentView_Previews: PreviewProvider {
    static var previews: some View {
        SFImageComponentView(symbolName: .play)
    }
}
