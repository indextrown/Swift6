//
//  AuthResponse.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/21/25.
//

import Foundation

struct AuthResponse: Codable {
    let data: AuthResponseData
    let message: String
}

struct AuthResponseData: Codable {
    var user: UserData
    var token: TokenData
    
    enum CodingKeys: CodingKey {
        case user
        case token
    }
}

