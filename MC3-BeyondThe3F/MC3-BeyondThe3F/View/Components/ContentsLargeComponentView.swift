//
//  ContentsLargeComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/20.
//

import SwiftUI

struct ContentsLargeComponentView: View {
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: 310, height: 379)
                .foregroundColor(.white)
            
        }
    }
}

struct ContentsLargeComponentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentsLargeComponentView()
    }
}
