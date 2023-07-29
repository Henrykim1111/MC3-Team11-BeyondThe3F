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
    @StateObject private var shazamViewModel = ShazamViewModel()
    @State private var musicName = ""
    @State private var artistName = ""
    @State private var musicImageUrl : URL?
    @State private var currentState : ShazamResultType = .listening
    @State private var musicId: String?
    
    @State private var circleScaleSmall: CGFloat = 1
    @State private var circleScaleBig: CGFloat = 1
    private let circleAnimationSmall = Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)
    private let circleAnimationBig = Animation.easeInOut(duration: 1).repeatForever(autoreverses: true).delay(0.1)
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
            }
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
        .frame(width: UIScreen.main.bounds.width)
        .frame(maxHeight: UIScreen.main.bounds.height)
        .frame(minWidth: 300, minHeight: 300)
        .padding()
        .navigationTitle("샤잠")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.custom(.background))
        .onAppear {
            shazamViewModel.startRecognition()
            startAnimation()
        }
        .onChange(of: shazamViewModel.currentItem) { _ in
            if let shazamResult = shazamViewModel.currentItem, shazamViewModel.shazaming {
                self.musicName = shazamResult.title ?? ""
                self.artistName = shazamResult.artist ?? ""
                self.currentState = .success
                self.musicId = shazamResult.appleMusicID ?? ""
                self.musicImageUrl = shazamResult.artworkURL
                shazamViewModel.stopRecognition()
            } else {
                self.currentState = .error
                
                shazamViewModel.stopRecognition()
            }
        }
        .onChange(of: currentState) { state in
            startAnimation()
        }
    }
    
    private func startAnimation(){
        switch currentState {
        case .listening:
            circleScaleSmall = 1
            circleScaleBig = 1
            withAnimation(self.circleAnimationSmall) {
                circleScaleSmall = 1.4
            }
            withAnimation(self.circleAnimationBig) {
                circleScaleBig = 1.2
            }
        default:
            break
        }
        
    }
}

extension ShazamView {
    // MARK: Top View
    var ShazamTopListeningView: some View {
        ZStack {
            ZStack {
                Rectangle()
                    .fill(Color.custom(.primary))
                    .frame(width: 150, height: 150)
                    .cornerRadius(75)
                    
                Image(systemName: "shazam.logo.fill")
                    .resizable()
                    .frame(width: 85, height: 85)
                    .foregroundColor(Color.custom(.white))
                    .cornerRadius(100)
            }
            .frame(width: 200, height: 200)
            .background(Color.custom(.primary).opacity(0.7))
            .cornerRadius(100)
            
            Circle()
                .strokeBorder(Color.custom(.secondary), lineWidth: 8)
                .frame(width: 240, height: 240)
                .scaleEffect(circleScaleSmall)
            
            Circle()
                .strokeBorder(Color.custom(.secondaryDark), lineWidth: 5)
                .frame(width: 350, height: 350)
                .scaleEffect(circleScaleBig)
        }
        
    }
    
    var ShazamTopSuccessView: some View {
        ZStack {
            if self.musicImageUrl == nil {
                Rectangle()
                    .fill(Color.custom(.primary))
                    .frame(width: 150, height: 150)
                    .cornerRadius(75)
                Image(systemName: "shazam.logo.fill")
                    .resizable()
                    .frame(width: 85, height: 85)
                    .foregroundColor(Color.custom(.white))
            } else {
                AsyncImage(url: musicImageUrl) { image in
                    image
                        .resizable()
                        .frame(width: 200, height: 200)
                        .cornerRadius(100)
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                        .frame(width: 200, height: 200)
                }
            }
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
        Text("노래를 찾고 있어요")
            .title2(color: .primary)
            .padding(.bottom, 170)
    }
    var ShazamBottomErrorView: some View {
        Text("노래를 찾지 못했어요")
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
                    .frame(width: UIScreen.main.bounds.width, height: 90)
                    .frame(minWidth: 300)
                    .cornerRadius(10)
            }
            .padding()
            VStack(spacing: 0) {
                Button {
                    // TODO: add to music play list the music Id
                    guard let appleMusicId = self.musicId else {
                        return
                    }
                    print(appleMusicId)
                } label: {
                    ButtonPlayComponentView()
                        .padding(2)
                        .background(Color.custom(.background))
                        .cornerRadius(25)
                }
                Spacer()
                    .frame(height: 10)
                Text(musicName)
                    .headline(color: .white)
                    .padding(.bottom, 5)
                Text(artistName)
                    .body2(color: .white)
            }
            VStack {
                Spacer()
                    .frame(height: 200)
                Button {
                    self.currentState = .listening
                    shazamViewModel.startRecognition()
                    
                } label: {
                    Text("다시 듣기")
                        .body2(color: .white)
                }
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
