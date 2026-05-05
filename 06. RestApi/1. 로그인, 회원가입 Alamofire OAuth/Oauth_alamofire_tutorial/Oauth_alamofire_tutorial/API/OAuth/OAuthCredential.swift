//
//  OAuthCredential.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/22/25.
//

import Foundation
import Alamofire

struct OAuthCredential: AuthenticationCredential {
    let accessToken: String
    let refreshToken: String
    let expiration: Date
    
    // 현재 시간이 만료 시간을 지났는지 단순 비교(30을 넘으면 그렇게된다)
    // var requiresRefresh: Bool { Date(timeIntervalSinceNow: 30) > expiration }
    // var requiresRefresh: Bool { Date() > expiration }
    
    // 만료일로부터 5분안이면 refresh할거냐
    var requiresRefresh: Bool { Date(timeIntervalSinceNow: 60 * 5) > expiration }
}
