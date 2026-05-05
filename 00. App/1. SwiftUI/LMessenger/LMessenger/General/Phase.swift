//
//  Phase.swift
//  LMessenger
//
//  Created by 김동현 on 7/8/25.
//

import Foundation

// 현재 로딩 상황에 맞는 뷰를 보여주기 위한 Phase
enum Phase {
    case notRequested
    case loading
    case success
    case fail
}
