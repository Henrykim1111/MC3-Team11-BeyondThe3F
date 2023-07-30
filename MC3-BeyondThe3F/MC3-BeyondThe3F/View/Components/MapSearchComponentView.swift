//
//  MapSearchComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/21.
//

import SwiftUI

struct MapSearchComponentView: View {
    @Binding var textInput: String
    
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
            .frame(maxWidth: 390)
            .frame(height: 48)
            .background(Color.custom(.secondaryDark))
            .cornerRadius(8)
            .colorScheme(.dark)
            .accentColor(.white)
    }
}

struct MapSearchComponentPreview: View {
    @State private var textInput = ""
    var body: some View {
        MapSearchComponentView(textInput: $textInput)
    }
}

struct MapSearchComponentPreview_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchComponentPreview()
    }
}
