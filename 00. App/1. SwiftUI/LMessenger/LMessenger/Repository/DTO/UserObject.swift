//
//  UserObject.swift
//  LMessenger
//
//  Created by 김동현 on 6/29/25.
//

import Foundation

// db에 값을 넣기 위한 규격
struct UserObject: Codable {
    var id: String
    var name: String
    var phoneNumber: String?
    var profileURL: String?
    var description: String?
}

extension UserObject {
    func toModel() -> User {
        return User(id: id,
                        name: name,
                        phoneNumber: phoneNumber,
                        profileURL: profileURL,
                        description: description)
    }
}

