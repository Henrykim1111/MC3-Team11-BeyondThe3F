//
//  EditDateView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/24.
//

import SwiftUI

struct EditDateView: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                DatePicker("", selection: $selectedDate,  displayedComponents: .date)
                            .datePickerStyle(WheelDatePickerStyle()).labelsHidden()
                Spacer()
                NavigationLink {
                    AddMusicView()
                        .toolbarRole(.editor)
                } label: {
                    PrimaryButtonComponentView(buttonType: .recordTheDate, backgroundColor: .primary)
                }

                
            }
            .frame(maxWidth: .infinity)
            .background(Color.custom(.background))
            .edgesIgnoringSafeArea(.all)
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
