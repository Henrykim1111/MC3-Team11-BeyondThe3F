//
//  SearchFailureComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/31.
//

import SwiftUI
enum FailureType {
    case musicSearchFailure
    case locationSearchFailure
}


struct SearchFailureComponentView: View {
    var failure: FailureType = .musicSearchFailure
    var body: some View {
        ScrollView {
            VStack{
                Spacer()
                    .frame(height: 30)
                Image("canNotFoundLogo")
                    .padding(.bottom, 32)
                Text("일치하는 항목을 찾을 수 없습니다.")
                    .body1(color: .gray400)
                    .padding(.bottom, 16)
                switch failure {
                case .locationSearchFailure:
                    Text("지역명을 다시 검색해서 저장된 음악을 찾아보세요.")
                        .body2(color: .gray600)
                case .musicSearchFailure:
                    Text("노래 제목을 다시 검색해서 음악을 저장해보세요.")
                        .body2(color: .gray600)
                }
            }
        }
    }
}

struct SearchFailureComponentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFailureComponentView()
    }
}
