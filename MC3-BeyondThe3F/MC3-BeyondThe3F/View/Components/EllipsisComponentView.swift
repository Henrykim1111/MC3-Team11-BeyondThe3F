//
//  EllipsisComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct EllipsisComponentView: View {
    var color: CustomColor = .white
    var body: some View {
        Image(systemName: "ellipsis")
            .frame(width: 32, height: 32)
            .foregroundColor(Color.custom(color))
            .rotationEffect(Angle(degrees: 90))
            
    }
}

struct EllipsisComponentView_Previews: PreviewProvider {
    static var previews: some View {
        EllipsisComponentView()
    }
}
