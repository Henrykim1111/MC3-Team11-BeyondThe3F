//
//  DateExtension.swift
//  MC3-BeyondThe3F
//
//  Created by Seungui Moon on 2023/07/26.
//

import Foundation

extension Date {
    static func formatToString(searchDate: Date) -> String{
       let formatter = DateFormatter()
       let dateString = formatter.string(from: searchDate)
       formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
       guard let date = formatter.date(from: dateString) else {
           return ""
       }
       formatter.dateFormat = "MM.dd"
       return formatter.string(from: date)
   }
}
