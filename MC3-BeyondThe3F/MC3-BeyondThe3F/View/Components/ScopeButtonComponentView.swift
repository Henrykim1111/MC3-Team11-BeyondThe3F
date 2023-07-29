//
//  ScopeButtonComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/20.
//

import SwiftUI

struct ScopeButtonComponentView: View {
    var foregroundColor = Color.custom(.white)
    var backgroundColor = Color.custom(.primary)
    
    
    var body: some View {
        ZStack{
            Circle()
                .fill(backgroundColor)
            Image(systemName: "scope")
                .frame(width: 24, height: 24)
                .foregroundColor(foregroundColor)
        }
        .frame(width: 48, height: 48)
    }
}

struct ScopeButtonComponentView_Previews: PreviewProvider {
    static var previews: some View {
        ScopeButtonComponentView()
    }
}
