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
                    AddMusicView()
                        .toolbarRole(.editor)
                        .onAppear {
                            musicUpdateViewModel.musicItemshared.generatedDate = selectedDate
                        }
                } label: {
                    PrimaryButtonComponentView(buttonType: .recordTheDate, backgroundColor: .primary)
                }
            case .backward:
                NavigationLink {
                    AddMusicView()
                        .toolbarRole(.editor)
                } label: {
                    Button {
                        musicUpdateViewModel.musicItemshared.generatedDate = selectedDate
                        dismiss()
                    } label: {
                        PrimaryButtonComponentView(buttonType: .recordTheDate, backgroundColor: .primary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.custom(.background))
        .navigationTitle("날짜 선택")
        .navigationBarTitleDisplayMode(.inline)
    }
        
}
   

struct EditDateView_Previews: PreviewProvider {
    static var previews: some View {
        EditDateView()
    }
}
