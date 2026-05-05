//
//  Todo.swift
//  VoiceMemo
//
//  Created by 김동현 on 12/27/24.
//

import Foundation

// forEach에서 값을 가지고 돌려주기 위해 Hashable 프로토콜 채택
struct Todo: Hashable {
    var title: String
    var time: Date
    var day: Date
    var selected: Bool
    
    var convertedDayAndTime: String {
        // 오늘 - 오후 03:00에 알림
        String("\(day.formattedDay) - \(time.formattedTime)에 알림")
    }
}

