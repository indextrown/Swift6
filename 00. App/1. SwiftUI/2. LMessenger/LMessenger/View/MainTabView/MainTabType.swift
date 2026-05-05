//
//  MainTabType.swift
//  LMessenger
//
//  Created by 김동현 on 1/14/25.
//

import Foundation

// MARK: - String -> rawValue, CaseIterable -> allCases
enum MainTabType: String, CaseIterable {
    case home
    case chat
    case phone
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .chat:
            return "대화"
        case .phone:
            return "통화"
        }
    }
    
    func imageName(selected: Bool) -> String {
        return selected ? "\(rawValue)_fill" : rawValue
    }
}

