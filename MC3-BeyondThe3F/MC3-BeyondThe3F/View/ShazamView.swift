//
//  ShazamView.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/25.
//

import SwiftUI

private enum ShazamResultType {
    case listening
    case success
    case notFound
    case error
}

struct ShazamView: View {
    @State private var musicName = "Big Wave"
    @State private var artistName = "293 studio"
    @State private var currentState : ShazamResultType = .success
    
    var body: some View {
        VStack {
            Spacer()
            switch currentState {
            case .listening:
                ShazamTopListeningView
            case .success:
                ShazamTopSuccessView
            case .notFound:
                ShazamTopErrorView
            case .error:
                ShazamTopErrorView
            }
            
            Spacer()
            switch currentState {
            case .listening:
                ShazamBottomListeningView
            case .success:
                ShazamBottomSuccessView
            case .notFound:
                ShazamBottomErrorView
            case .error:
                ShazamBottomErrorView
            }
        }
        .frame(width: UIScreen.main.bounds.size.width, height: .infinity)
        .padding()
        .navigationTitle("샤잠")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.custom(.background))
    }
}
extension ShazamView {
    // MARK: Top View
    var ShazamTopListeningView: some View {
        ZStack {
            Rectangle()
                .fill(Color.custom(.primary))
                .frame(width: 150, height: 150)
                .cornerRadius(75)
            Image(systemName: "shazam.logo.fill")
                .resizable()
                .frame(width: 85, height: 85)
                .foregroundColor(Color.custom(.white))
        }
        .frame(width: 200, height: 200)
        .background(Color.custom(.primary).opacity(0.7))
        .cornerRadius(100)
    }
    
    var ShazamTopSuccessView: some View {
        ZStack {
            Rectangle()
                .fill(Color.custom(.primary))
                .frame(width: 150, height: 150)
                .cornerRadius(75)
            Image(systemName: "shazam.logo.fill")
                .resizable()
                .frame(width: 85, height: 85)
                .foregroundColor(Color.custom(.white))
        }
        .frame(width: 200, height: 200)
        .background(Color.custom(.primary).opacity(0.7))
        .cornerRadius(100)
    }
    
    var ShazamTopErrorView: some View {
        ZStack {
            Rectangle()
                .fill(Color.custom(.primary))
                .frame(width: 150, height: 150)
                .cornerRadius(75)
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 85, height: 85)
                .foregroundColor(Color.custom(.white))
        }
        .frame(width: 200, height: 200)
        .background(Color.custom(.primary).opacity(0.7))
        .cornerRadius(100)
    }
    
    // MARK: Bottom View
    var ShazamBottomListeningView: some View {
        Text("Listening...")
            .title2(color: .primary)
            .padding(.bottom, 170)
    }
    var ShazamBottomErrorView: some View {
        Text("노래가 무엇인지 파악하지 못했어요")
            .title2(color: .primary)
            .padding(.bottom, 170)
    }
    var ShazamBottomSuccessView : some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 24)
                Rectangle()
                    .fill( LinearGradient(
                        gradient: Gradient(
                            colors: [Color.custom(.secondary), Color.custom(.background)]),
                            startPoint: .top,endPoint: .bottom))
                    .frame(width: 390,height: 90)
                    .cornerRadius(10)
            }
            VStack(spacing: 0) {
                ButtonPlayComponentView()
                    .padding(2)
                    .background(Color.custom(.background))
                    .cornerRadius(25)
                Spacer()
                    .frame(height: 10)
                Text(musicName)
                    .headline(color: .white)
                    .padding(.bottom, 5)
                Text(artistName)
                    .body2(color: .white)
            }
        }
        .frame(height: 120)
        .padding(.bottom, 80)
    }
}

struct ShazamView_Previews: PreviewProvider {
    static var previews: some View {
        ShazamView()
    }
}
