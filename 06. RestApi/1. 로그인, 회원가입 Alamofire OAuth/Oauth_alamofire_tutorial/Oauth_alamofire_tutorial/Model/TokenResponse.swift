//
//  TokenResponse.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/22/25.
//

import Foundation

// MARK: - Welcome
struct TokenResponse: Codable {
    let data: TokenResponseData
    let message: String
}

// MARK: - DataClass
struct TokenResponseData: Codable {
    let token: TokenData
}

