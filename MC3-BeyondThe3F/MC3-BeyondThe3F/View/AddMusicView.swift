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
    
    
    
    
    var destination : some View {
        Group {
            switch self {
            case .music:
                MainTabView()
            case .location:
                EditMapPositionView()
            case .date:
                EditDateView()
            }
        }
    }
}

struct MusicNameRow: View {
    @State var itemData: AddMusicItemData
    
    
    var body: some View {
        NavigationLink {
            itemData.destination
        } label: {
            Text("\(itemData.description)")
        }
    }
}
struct AddMusicView: View {
    var body: some View {
        NavigationStack{
            VStack{
                    List{
                        ForEach(AddMusicItemData.allCases, id: \.self) { addCase in
                            MusicNameRow(itemData: addCase)
                        }
                    }
                    Spacer()
                    NavigationLink {
                        MainTabView()
                    } label: {
                        PrimaryButtonComponentView(buttonType: .forSave, backgroundColor: .primary)
                    }
                    .navigationTitle("음악 추가")
            }
            
            
            
            
            
        }
    }
    
    struct AddMusicView_Previews: PreviewProvider {
        static var previews: some View {
            AddMusicView()
        }
    }
}
