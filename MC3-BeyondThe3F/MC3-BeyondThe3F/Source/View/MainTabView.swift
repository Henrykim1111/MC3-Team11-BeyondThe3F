//
//  MainTabView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/18.
//

import SwiftUI

struct MainTabView: View {
    @State private var showWelcomeSheet = false
    @AppStorage("isFirst") private var isFirst = true
    @AppStorage("showWelcome") private var showWelcome = true
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.custom(.gray200))
        UITabBar.appearance().backgroundColor = UIColor(Color.custom(.background))
    }
    
    var body: some View {
        TabView() {
            Group {
                BucketView()
                    .tabItem {
                        Image(systemName: "tray.full.fill")
                        Text("보관함")
                    }
                    .onAppear{
                        if showWelcome {
                            showWelcomeSheet = true
                        }
                        Task{
                            await MusicAuthManger.requestMusicAuth()
                        }
                    }
                MapView()
                    .tabItem {
                        Image(systemName: "map.fill")
                        Text("지도")
                    }
            }
            .toolbarBackground(Color.custom(.background), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .accentColor(.custom(.primary))
        .sheet(isPresented: $showWelcomeSheet, onDismiss: {
            showWelcome = false
        },content: {
            WelcomeSheetComponentView()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        })
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
