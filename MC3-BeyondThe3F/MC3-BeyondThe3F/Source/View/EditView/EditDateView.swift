//
//  EditDateView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/24.
//

import SwiftUI

struct EditDateView: View { 
    var nextProcess: NextProcess = .forward
    @ObservedObject private var musicUpdateViewModel = MusicItemUpdateViewModel.shared
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack{
            Spacer()
            DatePicker("", selection: $selectedDate,  displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle()).labelsHidden()
            Spacer()
            switch nextProcess {
            case .forward:
                NavigationLink {
                    AddMusicView(nextProcess: .forward)
                        .toolbarRole(.editor)
                } label: {
                    PrimaryButtonComponentView(buttonType: .recordTheDate, backgroundColor: .primary)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    musicUpdateViewModel.musicItemshared.generatedDate = selectedDate
                })
            case .backward:
                Button {
                    musicUpdateViewModel.musicItemshared.generatedDate = selectedDate
                    dismiss()
                } label: {
                    PrimaryButtonComponentView(buttonType: .recordTheDate, backgroundColor: .primary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.custom(.background))
        .navigationTitle("날짜 선택")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            
        }
        
    }
        
}
   

struct EditDateView_Previews: PreviewProvider {
    static var previews: some View {
        EditDateView()
    }
}
