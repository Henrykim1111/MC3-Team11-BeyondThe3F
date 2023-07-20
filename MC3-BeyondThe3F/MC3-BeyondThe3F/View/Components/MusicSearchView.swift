//
//  MusicSearchView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/20.
//

import SwiftUI

struct MusicSearchView: View {
    @State private var textInput: String = ""
    var body: some View {
        HStack{
            HStack {
                Image(systemName: "magnifyingglass")
                Spacer()
                    .frame(width: 20)
                TextField("음악을 검색해보세요", text: $textInput)
                Spacer()
                Image(systemName: "mic.fill")
                          

                       
                   }.padding()
                .foregroundColor(.white)
                .padding()
                .frame(width: 350, height: 48)
                .background(Color.custom(.secondaryDark))
                .cornerRadius(4)
                .colorScheme(.dark)
                .accentColor(.white)
            Spacer()
            Image(systemName: "gearshape.fill")
                .foregroundColor(.white)
               }
        }
        
    }


struct MusicSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MusicSearchView()
    }
}
