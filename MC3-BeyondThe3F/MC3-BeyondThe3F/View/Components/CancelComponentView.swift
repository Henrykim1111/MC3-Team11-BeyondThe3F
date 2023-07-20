//
//  CancelComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct CancelComponentView: View {
    var color: CustomColor = .white
    var body: some View {
        Image(systemName: "xmark")
            .frame(width: 24, height: 24)
            .foregroundColor(Color.custom(.white))
    }
}

struct CancelComponentView_Previews: PreviewProvider {
    static var previews: some View {
        CancelComponentView()
    }
}
