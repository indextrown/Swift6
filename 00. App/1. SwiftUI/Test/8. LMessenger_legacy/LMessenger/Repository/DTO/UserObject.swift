//
//  UserObject.swift
//  LMessenger
//
//  Created by 김동현 on 11/1/24.
//

import Foundation

struct UserObject: Codable { // 직렬화 가능
    var id: String
    var name: String
    var phoneNumber: String?
    var profileURL: String?
    var description: String?
}

extension UserObject {
    func toModel() -> User {
        .init(id: id,
              name: name,
              phoneNumber: phoneNumber,
              profileURL: profileURL,
              description: description
        )
    }
}
