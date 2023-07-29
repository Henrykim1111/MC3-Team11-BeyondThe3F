//
//  ContentView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/18.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @AppStorage("isFirst") private var isFirst = false
    
    var body: some View {
        if isFirst {
            WTMusicSearchView()
        } else {
            MainTabView()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
