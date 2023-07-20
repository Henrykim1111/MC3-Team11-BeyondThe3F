//
//  TrayComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct TrayComponentView: View {
    var color: CustomColor = .secondary
    var body: some View {
        Image(systemName: "tray.full.fill")
           
            .frame(width: 24, height: 24)
            .foregroundColor(Color.custom(color))
    }
}

struct TrayComponentView_Previews: PreviewProvider {
    static var previews: some View {
        TrayComponentView()
    }
}
