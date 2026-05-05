//
//  MyProfileMenuType.swift
//  LMessenger
//
//  Created by 김동현 on 11/18/24.
//

import Foundation

/*
 Hashable
 - 열거형 또는 구조체를 해시 값으로 표현하는 ㅡ로토콜
 - 고유한 식별자로 작동, 주로 컬렉션(Set, Dictionary)에서 열거형을 key로 사용 가능
 
 예시)
 let menuSet: Set<MyProfileMenuType> = [.studio, .decorate, .keep]
 if menuSet.contains(.studio) {
     print("스튜디오 메뉴가 포함되어 있습니다.")
 }

 CaseIterable
 - 열거형의 모든 케이스를 배열 형태로 제공하는 프로토콜
 - 이 프로토콜을 채택하면 자동으로 allCases라는 프로퍼티가 생성되며, 열거형의 모든 케이스를 순회하거나 접근할 수 있다
 
 예시)
 for menu in MyProfileMenuType.allCases {
     print(menu.description) // "스튜디오", "꾸미기", "Keep", "스토리"
 }

 결론
 Hashable: 열거형을 컬렉션에서 사용 가능하게 하며, 고유 식별자를 제공.
 CaseIterable: 열거형의 모든 케이스를 반복 가능하게 하여 동적 UI 구성 또는 로직 구현에 유용.
 
 
 */
enum MyProfileMenuType: Hashable ,CaseIterable {
    case studio
    case decorate
    case keep
    case story
    
    var description: String {
        switch self {
        case .studio:
            return "스튜디오"
        case .decorate:
            return "꾸미기"
        case .keep:
            return "Keep"
        case .story:
            return "스토리"
        }
    }
    
    var imageName: String {
        switch self {
            
        case .studio:
            return "mood"
        case .decorate:
            return "palette"
        case .keep:
            return "bookmark_profile"
        case .story:
            return "play_circle"
        }
    }
}
