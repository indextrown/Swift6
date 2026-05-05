//
//  User.swift
//  LMessenger
//
//  Created by 김동현 on 6/21/25.
//

import Foundation

struct User {
    var id: String
    var name: String
    var phoneNumber: String?
    var profileURL: String?
    var description: String?
}

extension User {
    func toObject() -> UserObject {
        return UserObject(id: id,
                          name: name,
                          phoneNumber: phoneNumber,
                          profileURL: profileURL,
                          description: description)
    }
}

extension User {
    static var stub1: User {
        .init(id: "user1_id", name: "유저1")
    }
    
    static var stub2: User {
        .init(id: "user2_id", name: "유저2")
    }
}

