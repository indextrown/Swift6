//
//  ReuseIdentifiable.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 4/6/25.
//

import UIKit

// MARK: - 테이블뷰 셀의 경우 ReuseIdentifiable를 설정해줘야 한다
protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get } // 가져올수만 있도록
}

// 이 프로토콜을 준수하면 자동적으로
extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: ReuseIdentifiable {}


