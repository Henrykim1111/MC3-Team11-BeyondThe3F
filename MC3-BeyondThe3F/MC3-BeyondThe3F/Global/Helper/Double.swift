//
//  File.swift
//  MC3-BeyondThe3F
//
//  Created by jaesik pyeon on 2023/07/28.
//

import Foundation


extension Double{
    var timeToString:String{
        var time = Int(self)
        return "\(time/60):\(time%60 < 10 ? "0\(time%60)" : "\(time%60)")"
    }
}
