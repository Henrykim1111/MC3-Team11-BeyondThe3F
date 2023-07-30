//
//  EditMusicView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/24.
//

import SwiftUI

enum AddMusicItemData: CaseIterable {
    case music
    case location
    case date
    
    var description: String {
        switch self {
        case .music:
            return "음악"
        case .location:
            return "위치"
        case .date:
            return "날짜"
        }
    }
    var additionalInfo: String {
            switch self {
            case .music:
                return "\(MusicItemUpdateViewModel.shared.musicItemshared.songName)"
            case .location:
                return "\(MusicItemUpdateViewModel.shared.musicItemshared.locationInfo)"
            case .date:
                return "\(MusicItemUpdateViewModel.shared.musicItemshared.generatedDate)"
            }
        }
    var destination : some View {
        Group {
            switch self {
            case .music:
                MainTabView()
            case .location:
                EditMapPositionView(nextProcess: .backward)
            case .date:
                EditDateView(nextProcess: .backward)
            }
        }
    }
}

struct MusicNameRow: View {
    @ObservedObject private var musicItemUpdateViewModel = MusicItemUpdateViewModel.shared
    @State var itemData: AddMusicItemData
    
    var body: some View {
        HStack (spacing: 16){
            Text("\(itemData.description)")
                .headline(color: .white)
                .foregroundColor(.white)
            
            Spacer()
                .frame(width: 180)
                
            NavigationLink(destination: itemData.destination) {
                Text(itemData.additionalInfo)
                    .body1(color: .gray500)
            }
        }
    }
}

struct AddMusicView: View {
    var nextProcess: NextProcess = .forward
    @ObservedObject private var musicItemUpdateViewModel = MusicItemUpdateViewModel.shared
    
    var body: some View {
        NavigationStack{
            VStack{
                VStack{
                    VStack(spacing:0){
                        Rectangle()
                            .foregroundColor(.black)
                            .cornerRadius(6)
                    }
                    .frame(width: 350, height: 350)
                    // TODO: frame 크기 조절
                }
                .background(Color.custom(.background))
                .padding(16)
                
                List{
                    ForEach(AddMusicItemData.allCases, id: \.self) { addCase in
                        MusicNameRow(itemData: addCase)
                            .listRowBackground(Color.custom(.background))
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                
                Spacer()
                
                Button {
                    musicItemUpdateViewModel.updateCoreDate()
                } label: {
                    PrimaryButtonComponentView(buttonType: .forSave, backgroundColor: .primary)
                }
            }
            .navigationTitle("음악 편집")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.custom(.background))
            .onAppear {
                print(musicItemUpdateViewModel.musicItemshared)
            }
            
        }
        
    }
    struct AddMusicView_Previews: PreviewProvider {
        static var previews: some View {
            AddMusicView()
        }
    }
}

