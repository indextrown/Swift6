//
//  Todo.swift
//  voiceMemo
//

import Foundation

// Foreach를 돌리기위한 Hashable 채택
struct Todo: Hashable {
    var title: String       // 타이틀
    var time: Date          // 오후 3시
    var day: Date           // 몇월 몇일
    var selected: Bool      // 선택유무
    
    // 뷰의 역할 단순화를 위해 Model에서 로직 처리
    var convertedDatAndTime: String {
        // 오늘 - 오후 03:00에 알림
        String("\(day.formattedDay) = \(time.formattedTime)에 알림")
    }
}

