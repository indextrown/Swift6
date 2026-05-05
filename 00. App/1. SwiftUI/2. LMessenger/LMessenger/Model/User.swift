//
//  User.swift
//  LMessenger
//
//  Created by 김동현 on 1/13/25.
//

import Foundation

struct User {
    var id: String
    var name: String
    var phoneNumber: String?
    var profileURL: String?
    var description: String?
}

// control + shift = 화살표 여러개 가능
extension User {
    // 함수 본문이 단일 표현식으로 이루어진 경우에만 return 생략 가능.
//    func toObject() -> UserObject {
//        .init(
//            id: id,
//            name: name,
//            phoneNumber: phoneNumber,
//            profileURL: profileURL,
//            description: description
//        )
//    }
}

 
extension User {
    static var stub1: User {
        .init(id: "user1_id", name: "인덱스")
    }
    
    static var stub2: User {
        .init(id: "user2_id", name: "홍길동")
    }
}

