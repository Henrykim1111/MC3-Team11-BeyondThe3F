//
//  ContentsSmallComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/20.
//

import SwiftUI

struct ContentsSmallComponentView: View {
    var body: some View {
        VStack{
            VStack(spacing:16){
                Rectangle()
                    .foregroundColor(.black)
                    .cornerRadius(6)
                HStack{
                    VStack(alignment:.leading){
                        Text("지곡동")
                            .title2(color: .gray700)
                            .foregroundColor(.black)
                            
                        Text("23년 6월")
                            .body1(color: .gray500)
                            .padding(.bottom, 2)
                    }
                    Spacer()
                    ButtonPlayComponentView()

                }.padding(.vertical,8)

            }.padding(16)
            .background(.white)
            .frame(width: 238, height: 291)
            //frame 크기 조절해서 쓰세요~~~
            //small: width: 238, height: 291 정도
        }
        .padding(16)
        .background(.white)
        
    }
}

struct ContentsSmallComponentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentsSmallComponentView()
    }
}
