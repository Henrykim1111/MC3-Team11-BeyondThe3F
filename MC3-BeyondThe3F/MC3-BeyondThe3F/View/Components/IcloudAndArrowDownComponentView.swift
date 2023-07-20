//
//  IcloudAndArrowDownComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct IcloudAndArrowDownComponentView: View {
    var color: CustomColor = .white
    var body: some View {
        Image(systemName: "icloud.and.arrow.down.fill")
            .frame(width: 24, height: 24)
            .foregroundColor(Color.custom(color))
    }
}

struct IcloudAndArrowDownComponentView_Previews: PreviewProvider {
    static var previews: some View {
        IcloudAndArrowDownComponentView()
    }
}
