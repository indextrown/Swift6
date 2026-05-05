//
//  UserData.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/21/25.
//

import Foundation

// List에서 쓰려면 Identifiable 준수해야함
// 서버에서 넘어온 사용자 데이터
struct UserData: Codable, Identifiable {
    var uuid: UUID = UUID()
    var id: Int
    var name: String
    var email: String
    var avatar: String
    
    // 변수명과 일치하면 안해도됨
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case avatar
    }
}
