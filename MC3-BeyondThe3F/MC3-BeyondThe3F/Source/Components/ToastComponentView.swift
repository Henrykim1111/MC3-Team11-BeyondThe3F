//
//  ToastView.swift
//  MC3-BeyondThe3F
//
//  Created by 이연정 on 2023/08/01.
//

import SwiftUI

struct ToastComponentView: View {
    
    @ObservedObject private var musicItemUpdateViewModel = MusicItemUpdateViewModel.shared
    
    var message: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(Color.custom(.secondary).opacity(0.9))
                .frame(width: .infinity)
                .frame(height: 48)
            Text(message)
                .body1(color: .white)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
    }
}

struct ToastComponentView_Previews: PreviewProvider {
    static var previews: some View {
        ToastComponentView(message: "저장되었습니다!")
    }
}
