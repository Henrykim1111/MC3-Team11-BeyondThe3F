//
//  TestComponentView.swift
//  MC3-BeyondThe3F
//
//  Created by 한영균 on 2023/07/19.
//

import SwiftUI

struct TestComponentView: View {
    var body: some View {
        ScrollView {
            VStack{
                SFImageComponentView(symbolName: .magnifyingGlass)
                SFImageComponentView(symbolName: .play,color: .primary)
                SFImageComponentView(symbolName: .gearShape,color: .gray500, width: 50, height: 50)
                ButtonPlayComponentView()
                SmallButtonComponentView()
                SmallButtonComponentView(sfImageName: .icloud, name: "앨범")
                PrimaryButtonComponentView()
                PrimaryButtonComponentView(buttonType: .recordThePosition, backgroundColor: .primary)
                PrimaryButtonComponentView(buttonType: .forSave, backgroundColor: .secondary)
            }
        }
    }
}

struct TestComponentView_Previews: PreviewProvider {
    static var previews: some View {
        TestComponentView()
    }
}
