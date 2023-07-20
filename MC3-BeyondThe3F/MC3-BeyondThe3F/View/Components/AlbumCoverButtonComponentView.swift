//
//  AlbumCoverButtonComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct AlbumCoverButtonComponentView: View {
    var backgroundColor: CustomColor = .gray700
    var foregroundColor: CustomColor = .white
 
    
    var body: some View {
        HStack{
            Image(systemName: "icloud.and.arrow.down.fill")
            Text("앨범 커버")
        }
        .frame(width: 110, height: 48)
        .background(Color.custom(.secondaryDark))
        .foregroundColor(Color.custom(.white))
        .cornerRadius(8)
        
    }
}

struct AlbumCoverButtonComponentView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumCoverButtonComponentView()
    }
}
