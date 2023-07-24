//
//  EditMusicView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/24.
//

import SwiftUI

struct AddMusicView: View {
    var body: some View {
        NavigationStack{
            VStack{
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
}

struct AddMusicView_Previews: PreviewProvider {
    static var previews: some View {
        AddMusicView()
    }
}
