//
//  MainDataModel.swift
//  MC3-BeyondThe3F
//
//  Created by jaesik pyeon on 2023/07/24.
//

import Foundation


class MainDataModel{
    static let shared = MainDataModel()
    private init(){}
    let loc = (lat:37.5,long:127.5)

    let musicItemDataModel = MusicItemDataModel.shared
    let locationManager = LocationManager.shared
    
    var getData:[MainVO]{
        var dic:[String:[MusicItem]] = [:]
        musicItemDataModel.musicList.forEach {
            if var arr = dic[$0.locationInfo ?? ""]{
                arr.append($0)
                dic[$0.locationInfo ?? ""] = arr
            }else{
                dic[$0.locationInfo ?? ""] = [$0]
            }
        }
        var tempArr:[[MusicItem]] = []
        for (_,value) in dic{
            tempArr.append(value)
        }
        dic.forEach {
            tempArr.append($0.value)
        }
        
        tempArr.sort{
            let left = locationManager.getDistance(latitude: $0[0].latitude, longitude: $0[0].longitude)
            let right = locationManager.getDistance(latitude: $1[0].latitude, longitude: $1[0].longitude)
            return left < right
        }

        return tempArr.map{ MainVO(locationInfo: $0[0].locationInfo ?? "", musicList: $0) }
    }
}
