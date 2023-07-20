//
//  ScopeButtonComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/20.
//

import SwiftUI

struct ScopeButtonComponentView: View {
    var body: some View {
        ZStack{
            Circle()
                .fill(Color.custom(.primary))
            Image(systemName: "scope")
                .frame(width: 24, height: 24)
        }
        .frame(width: 48, height: 48)
        //색깔 바꿔서 사용
        
        
        
    }
}

struct ScopeButtonComponentView_Previews: PreviewProvider {
    static var previews: some View {
        ScopeButtonComponentView()
    }
}
