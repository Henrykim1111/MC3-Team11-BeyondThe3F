//
//  NavigationHelper.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/29.
//

import SwiftUI

class NavigationHelper: ObservableObject {
    static let shared = NavigationHelper()
    private init(){ }
    
    @Published var path = NavigationPath()
    
    func goToMainView(){
        path = .init()
    }
    
    func dismiss(){
        path.removeLast()
    }
}
