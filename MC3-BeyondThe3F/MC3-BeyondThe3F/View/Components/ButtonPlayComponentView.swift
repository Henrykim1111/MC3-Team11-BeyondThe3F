//
//  ButtonPlayComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct ButtonPlayComponentView: View {
    var body: some View {
        ZStack{
            VStack {
                
            }
                .frame(width: 48, height: 48)
                .background(Color.custom(.primary))
                .cornerRadius(100)
            
            VStack {
                Image(systemName: "play.fill")
                    
                    .frame(width: 18, height: 24)
                    .foregroundColor(Color.custom(.white))
                    .offset(x: 1, y: 0)
                    
            }
        }
    }
        
    
    struct ButtonPlayComponentView_Previews: PreviewProvider {
        static var previews: some View {
            ButtonPlayComponentView()
        }
    }
}
