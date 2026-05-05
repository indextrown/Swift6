//
//  ArrayExtension.swift
//  LBSRiders
//
//  Created by 김동현 on 7/7/25.
//

import Foundation

extension Array {
    /// 배열에 안전하게 접근할 수 있는 서브스크립트
    /// 인덱스가 유효하지 않으면 nil 반환
    subscript (safe index: Int) -> Element? {
        if 0 <= index && index < self.count {
            return self[index]
        }
        return nil
    }
}
