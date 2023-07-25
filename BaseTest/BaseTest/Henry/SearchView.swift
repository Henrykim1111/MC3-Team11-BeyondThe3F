//
//  SearchView.swift
//  BaseTest
//
//  Created by Hyungmin Kim on 2023/07/23.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        HStack{
            Rectangle()
                .padding()
            Image(systemName: "shazam.logo.fill")
                .frame(width: 29, height: 29)
        }
        .frame(width: 390, height: 64)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
