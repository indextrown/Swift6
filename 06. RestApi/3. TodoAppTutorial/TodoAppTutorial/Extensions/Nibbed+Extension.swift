//
//  Nibbed+Extension.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 4/6/25.
//

import UIKit

// MARK: - 셀 관련
// 프로토콜은 약속이다 -> Nibbed을 준수하면 uinib변수를 가지고 있다
protocol Nibbed {
    // 선언
    static var uinib: UINib { get } // 가져올수만 있도록
}

extension Nibbed {
    // 정의: 값을 설정
    static var uinib: UINib {
        // Nib파일은 TodoCell과 동일              // 클래스 자체 이름
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }
}

// TodoCell 자체는 UITableViewCell이므로 자동적으로 TodoCell.nib변수 사용 가능해진다
extension UITableViewCell: Nibbed {}
