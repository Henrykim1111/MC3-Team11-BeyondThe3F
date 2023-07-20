//
//  ChevronFrontComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct ChevronForwardComponentView: View {
    var color: CustomColor = .white
    var body: some View {
        Image(systemName: "chevron.forward")
            
            .frame(width: 24, height: 24)
            .foregroundColor(Color.custom(color))
    }
}
    struct ChevronForwardComponentView_Previews: PreviewProvider {
        static var previews: some View {
            ChevronForwardComponentView()
        }
    }

