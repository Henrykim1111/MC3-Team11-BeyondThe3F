//
//  MusicListRowView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/20.
//

import SwiftUI

struct MusicListRowView: View {
    var body: some View {
        HStack{
            Spacer()
                .frame(width: 20)
            Rectangle()
                .frame(width: 60, height: 60)
                .cornerRadius(8)
                .foregroundColor(.white)
            Spacer()
                .frame(width: 16)
            VStack(alignment: .leading){
                Text("최애의 아이")
                    .body1(color: .white)
                    .padding(.bottom, 4)
                Text("YOASOBI")
                    .body2(color: .gray500)
            }
            Spacer()
                .frame(width: 106)
            PlayButtonComponentView()
            EllipsisComponentView()
            
            
            
            
        }
        .frame(width: 390, height: 88)
        
    }
}

struct MusicListRowView_Previews: PreviewProvider {
    static var previews: some View {
        MusicListRowView()
    }
}
