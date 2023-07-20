//
//  ScopeShapeComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct ScopeComponentView: View {
    var color: CustomColor = .white
    var body: some View {
        Image(systemName: "scope")
            .resizable()
            .frame(width: 28, height: 24)
            .foregroundColor(Color.custom(color))
    }
}

struct ScopeComponentView_Previews: PreviewProvider {
    static var previews: some View {
        ScopeComponentView()
    }
}
