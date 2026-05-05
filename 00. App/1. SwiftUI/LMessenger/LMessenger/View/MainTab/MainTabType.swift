//
//  MainTabType.swift
//  LMessenger
//
//  Created by 김동현 on 6/29/25.
//

import Foundation

enum MainTabType: String, CaseIterable {
    case home
    case chat
    case phone
    
    var title: String {
        switch self {
        case .home:
            "홈"
        case .chat:
            "대화"
        case .phone:
            "통화"
        }
    }
    
    func imageName(selected: Bool) -> String {
        selected ? "\(rawValue)_fill" : rawValue
    }
}
