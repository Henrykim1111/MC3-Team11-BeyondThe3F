//
//  MusicPlayerComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/20.
//

import SwiftUI

struct MusicPlayerComponentView: View {
    var body: some View {
        HStack{
            Spacer()
                .frame(width: 16)
            Rectangle()
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            Spacer()
                .frame(width: 16)
            VStack(alignment:.leading){
                Text("Title")
                    .body1(color: .white)
                    .padding(.bottom, 8)
                Text("subtitle1")
                    .body2(color: .gray500)
            }
            Spacer()
            HStack(spacing: 20) {
                SFImageComponentView(symbolName: .play, color: .white, width: 20)
                SFImageComponentView(symbolName: .forward, color: .white, width: 35)
                SFImageComponentView(symbolName: .list, color: .white)
            }
            Spacer()
                .frame(width: 10)
        }
        .foregroundColor(.white)
        .frame(width: 390, height: 88)
        .background(Color.custom(.secondaryDark))
    }
}

struct MusicPlayerComponentView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayerComponentView()
    }
}
