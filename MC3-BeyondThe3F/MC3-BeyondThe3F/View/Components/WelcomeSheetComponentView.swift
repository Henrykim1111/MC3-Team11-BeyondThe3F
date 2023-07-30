//
//  WelcomeSheetComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/29.
//

import SwiftUI

struct WelcomeSheetComponentView: View {
    var body: some View{
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 30)
            Text("축하합니다!")
                .headline(color: .white)
                .padding(.bottom, 10)
            Text("지도 위에 음악이 기록되었어요")
                .headline(color: .white)
                .padding(.bottom, 30)
            Image("welcomeSheetImage")
                .padding(.bottom, 20)
            Text("더 많은 음악을 추가해서 추억을 기록해보세요")
                .caption(color: .gray500)
            HStack{
                Spacer()
            }
            Color.custom(.secondaryDark)
        }
        .padding()
        .background(Color.custom(.secondaryDark))
    }
}

struct WelcomeSheetComponentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeSheetComponentView()
    }
}
