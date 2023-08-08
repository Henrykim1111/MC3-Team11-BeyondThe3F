//
//  MusicSubscriptionManager.swift
//  Tune Spot
//
//  Created by Seungui Moon on 2023/08/08.
//

import Foundation
import MusicKit
import _MusicKit_SwiftUI

final class MusicSubscriptionManager: ObservableObject {
    static let shared = MusicSubscriptionManager()
    private init() {}
    
    @Published var subscriptionState: MusicSubscription?
    @Published var currentId: MusicItemID?
    
    
    var offerOptions: MusicSubscriptionOffer.Options {
        var offerOptions = MusicSubscriptionOffer.Options()
        offerOptions.itemID = currentId
        return offerOptions
    }

    
    
}
