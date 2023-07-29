//
//  MainTabView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/18.
//

import SwiftUI

struct MainTabView: View {
    @State private var showWelcomeSheet = false
    var body: some View {
        TabView {
            BucketView()
                .tabItem {
                    Image(systemName: "tray.full.fill")
                    Text("보관함")
                }
            MapView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("지도")
                }
        }
        .onAppear{
            insertDummy()
            Task{
                await AuthManger.requestMusicAuth()
            }           
        }
        .sheet(isPresented: $showWelcomeSheet, content: {
            WelcomeSheetComponentView()
        })
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
