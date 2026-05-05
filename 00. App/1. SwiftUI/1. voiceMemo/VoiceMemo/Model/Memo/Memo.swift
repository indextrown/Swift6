//
//  Memo.swift
//  VoiceMemo
//
//  Created by 김동현 on 1/2/25.
//

import Foundation

struct Memo: Hashable {
    var title: String
    var content: String
    var date: Date
    var id = UUID()
    
    var convertedDate: String {
        String("\(date.formattedDay) - \(date.formattedTime)")
    }
}
