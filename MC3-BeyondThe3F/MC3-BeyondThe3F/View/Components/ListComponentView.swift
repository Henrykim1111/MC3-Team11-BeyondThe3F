//
//  ListComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct ListComponentView: View {
    var color: CustomColor = .white
    var body: some View {
        Image(systemName: "list.bullet")
            
            .frame(width: 32, height: 32)
            .foregroundColor(Color.custom(color))
    }
    }


struct ListComponentView_Previews: PreviewProvider {
    static var previews: some View {
        ListComponentView()
    }
}
