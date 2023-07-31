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
            if isFirst {
                showWelcomeSheet = true
            }           
        }
        .sheet(isPresented: $showWelcomeSheet, onDismiss: {
            isFirst = false
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
