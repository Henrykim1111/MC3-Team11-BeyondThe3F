//
//  PlayButtonBar.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct PlayButtonBar: View {
    var body: some View {
        ZStack{
            
            VStack{
               
                    
            }
            .foregroundColor(.white)
            .frame(width: 167, height: 48)
            .background(Color.custom(.primary))
            .cornerRadius(4)
            HStack{
                Image(systemName: "play.fill")
                    .foregroundColor(.white)
                Text("재생")
                    .foregroundColor(.white)
                    
        
            }
            
            
        }
       
    }
}

struct PlayButtonBar_Previews: PreviewProvider {
    static var previews: some View {
        PlayButtonBar()
    }
}
