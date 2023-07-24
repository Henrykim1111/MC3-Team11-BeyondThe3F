//
//  EditDateView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/24.
//

import SwiftUI

struct EditDateView: View {
    @State private var wakeUp = Date()
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                DatePicker("", selection: $wakeUp,  displayedComponents: .date)
                            .datePickerStyle(WheelDatePickerStyle()).labelsHidden()
                Spacer()
                NavigationLink {
                    AddMusicView()
                        .toolbarRole(.editor)
                } label: {
                    PrimaryButtonComponentView(buttonType: .recordTheDate, backgroundColor: .primary)
                }

                
            }
            .navigationTitle("날짜 선택")
            .navigationBarTitleDisplayMode(.inline)
        }
        .tint(.custom(.white))
    }
}

struct EditDateView_Previews: PreviewProvider {
    static var previews: some View {
        EditDateView()
    }
}
