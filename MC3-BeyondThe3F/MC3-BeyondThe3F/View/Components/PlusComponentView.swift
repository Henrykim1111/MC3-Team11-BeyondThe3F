//
//  PlusComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct PlusComponentView: View {
    var color: CustomColor = .white
    var body: some View {
        Image(systemName: "plus")
            .frame(width: 32, height: 32)
            .foregroundColor(Color.custom(color))
    }
}

struct PlusComponentView_Previews: PreviewProvider {
    static var previews: some View {
        PlusComponentView()
    }
}
