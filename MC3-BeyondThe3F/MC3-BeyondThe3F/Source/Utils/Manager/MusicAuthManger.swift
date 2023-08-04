//
//  AuthManager.swift
//  MC3-BeyondThe3F
//
//  Created by jaesik pyeon on 2023/07/25.
//

import Foundation
import MusicKit

class MusicAuthManger{
    static func requestMusicAuth() async {
        let status = await MusicAuthorization.request()
        switch status {
        case .authorized:
            print("auth success")
        case .denied:
            print("auth denied")
        case .restricted:
            print("auth restricted")
        default:
            return
        }
    }
}
