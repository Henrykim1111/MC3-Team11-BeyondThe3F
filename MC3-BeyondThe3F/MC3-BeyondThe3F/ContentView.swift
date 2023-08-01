//
//  ContentView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/18.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @AppStorage("isFirst") private var isFirst = true
    @State var isLoading: Bool = true
    
    
    var body: some View {
        ZStack {
            if isLoading {
                launchScreenView
            } else {
                if isFirst {
                    WTMusicSearchView()
                } else {
                    MainTabView()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                withAnimation(.easeInOut(duration: 1)) {
                    isLoading.toggle()
                }
            })
        }
    }
}

extension ContentView {
    
    var launchScreenView: some View {
        
        ZStack(alignment: .center) {
            
            LinearGradient(gradient: Gradient(colors: [Color.custom(.background), Color("SubPrimaryColor")]),
                            startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            VStack {
                Image("launchScreenImage1")
                Spacer()
                    .frame(height: 43)
                Image("launchScreenImage2")
                Spacer()
                    .frame(height: 43)
                Text("내가 갔던 장소에서 내가 들었던 노래를\n지금 저장하고 추억해보세요!")
                    .body2(color: .white)
                    .lineSpacing(7)
                    .multilineTextAlignment(.center)
            }
        }
        .background(Color.custom(.background))
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
