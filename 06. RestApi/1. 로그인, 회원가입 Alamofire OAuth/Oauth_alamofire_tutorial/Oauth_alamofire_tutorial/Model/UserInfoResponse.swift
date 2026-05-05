//
//  UserInfoResponse.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/22/25.
//

import Foundation

// MARK: - UserInfoResponse
struct UserInfoResponse: Codable {
    let data: UserInfoResponseData
    let message: String
}

// MARK: - DataClass
struct UserInfoResponseData: Codable {
    let user: UserData
}


