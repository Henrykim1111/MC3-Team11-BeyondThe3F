//
//  NavigationHelper.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/29.
//

import SwiftUI

class BucketNavigationManager: ObservableObject {
    static let shared = BucketNavigationManager()
    private init(){ }
    
    @Published var path = NavigationPath()
    
    func goToMainView(){
        path = .init()
    }
    
    func goPrevView(count: Int = 1){
        path.removeLast()
    }
    
    func dismiss(){
        path.removeLast()
    }
}
