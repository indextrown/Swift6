//
//  Memo.swift
//  voiceMemo
//

import Foundation

// MARK: - 인스턴스를 고유하게 식별하기 위해 사용 -> forEach, 딕셔너리 key, Set
// hashable은 내부적으로 Equtable을 포함하고 있다
// hashable은 내부적으로 hashValue를 계산하여 고유 식별자로 활용한다. 이를 위해 UUID와 같은 고유 값이 있으면 손쉽게 구현가능
struct Memo: Hashable {
    var title: String
    var content: String
    var date: Date
    var id = UUID() // 고유 식별자를 제공하는 편리한 방법(객체가 고유하기 위해, 메모내용과 날짜가  같아도 다른 메모로 간주히야할때)
    
    var convertedDate: String {
        String("\(date.formattedDay) - \(date.formattedTime)")
    }
}
