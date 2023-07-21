//
//  MapSearchComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/21.
//

import SwiftUI

struct MapSearchComponentView: View {
    @State private var textInput: String = ""
    
    var body: some View {
            HStack {
                SFImageComponentView(
                    symbolName: .magnifyingGlass,
                    color: .white)
                Spacer()
                    .frame(width: 20)
                TextField("장소를 검색해보세요", text: $textInput)
                    
                Spacer()
            }
            .padding()
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: 390)
            .frame(height: 48)
            .background(Color.custom(.secondaryDark))
            .cornerRadius(4)
            .colorScheme(.dark)
            .accentColor(.white)
    }
}

struct MapSearchComponentView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchComponentView()
    }
}
