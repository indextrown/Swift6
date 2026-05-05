//
//  Phase.swift
//  LMessenger
//
//  Created by 김동현 on 1/16/25.
//

import Foundation

// 이름이 보이기 전에 디폴트 이미지가 보일 수 있음 ->  개선 필요를 위해 Phase(로딩전, 로딩중, 끝났는지에 대한) 필요
enum Phase {
    case notRequested // 요청안했는지
    case loading      // 로딩중인지
    case success      // 로딩 성공했는지
    case fail         // 로딩 실패했는지
}
