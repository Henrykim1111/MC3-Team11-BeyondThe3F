//
//  AustinView.swift
//  BaseTest
//
//  Created by Seungui Moon on 2023/07/12.
//

import SwiftUI

struct AustinView: View {
    var body: some View {
        TabView {
            AustinHomeView()
                .tabItem {
                    Label("Home", systemImage: "tray.and.arrow.down.fill")
                }
            AustinMapView()
                .tabItem {
                    Label("Home", systemImage: "tray.and.arrow.down.fill")
                }
        }
    }
}

struct AustinView_Previews: PreviewProvider {
    static var previews: some View {
        AustinView()
    }
}
