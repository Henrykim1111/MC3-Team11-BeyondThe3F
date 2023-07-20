//
//  SFImageComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/20.
//

import SwiftUI

struct SFImageComponentView: View {
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
            }
        }
    }
    private let symbolName: SFImageType = .map
    private let color: CustomColor = .gray700
    private let width = 24
    private let height = 24
    
    var body: some View {
        Image(systemName: symbolName.name)
            .frame(width: CGFloat(width), height: CGFloat(height))
            .foregroundColor(Color.custom(color))
    }
}

struct SFImageComponentView_Previews: PreviewProvider {
    static var previews: some View {
        SFImageComponentView()
    }
}
