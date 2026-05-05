//
//  Rps.swift
//  RPSGame
//
//  Created by 김동현 on 2/13/25.
//

import UIKit

// MARK: - 메모리의 코드 영역에 들어간다.
// MARK: - 전역으로 정의하여서 데이터 영역에도 들어간다.
enum RPS: Int { // 원시값 Int 설정
    case ready    // 0
    case rock     // 1
    case paper    // 2
    case scissors // 3
    
    // 계산 속성
    var rpsInfo: (image: UIImage, name: String) {
        switch self {
        case .ready:
            return (#imageLiteral(resourceName: "ready"), "준비")
        case .rock:
            return (#imageLiteral(resourceName: "rock"), "바위")
        case .paper:
            return (#imageLiteral(resourceName: "paper"), "보")
        case .scissors:
            return (#imageLiteral(resourceName: "scissors"), "가위")
        }
    }
}

