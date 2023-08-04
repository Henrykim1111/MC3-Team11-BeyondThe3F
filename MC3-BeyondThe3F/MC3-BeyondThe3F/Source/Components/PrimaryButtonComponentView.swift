//
//  PrimaryButtonComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/20.
//

import SwiftUI

struct PrimaryButtonComponentView: View {
    enum PrimaryButtonType {
        case saved
        case forSave
        case recordThePosition
        case recordTheDate
        
        var content: String {
            switch self {
            case .saved:
                return "저장되었습니다!"
            case .forSave:
                return "저장"
            case .recordThePosition:
                return "이 위치에 기록"
            case .recordTheDate:
                return "이 날짜로 저장"
            }
        }
    }
    var buttonType: PrimaryButtonType = .saved
    var backgroundColor: CustomColor = .secondaryDark
    var foregroundColor: CustomColor = .white
    
    var body: some View {
        Text(buttonType.content)
            .foregroundColor(Color.custom(foregroundColor))
            .frame(maxWidth: 350)
            .frame(height: 48)
            .background(Color.custom(backgroundColor))
            .cornerRadius(8)
            .opacity(buttonType == .saved ? 0.9 : 1)
    }
}

struct PrimaryButtonComponentView_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButtonComponentView()
    }
}
