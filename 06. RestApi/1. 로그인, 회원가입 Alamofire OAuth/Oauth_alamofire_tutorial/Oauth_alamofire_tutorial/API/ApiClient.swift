//
//  ApiClient.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/21/25.
//

import Alamofire

// api 호출 클라이언트 -> 핵심이 세션에 계속 접근하는것
final class APiCient {
    // 싱글톤(한번 사용한 메모리를 계속 사용)
    static let shared = APiCient()
    
    // static let BASE_URL = "https://dev-jeongdaeri-oauth.tk/api"
    // static let BASE_URL = "https://phplaravel-574671-2229990.cloudwaysapps.com/api/user/info"
    static let BASE_URL = "https://phplaravel-574671-2962113.cloudwaysapps.com/api/v2"
    
    let interceptors = Interceptor(interceptors: [
        BaseInterceptor()   // application/json을 위한것 -> 기본 필수 파라미터를 넣거나 기본 사용자의 정보를 api를 태울떄마다 하겠다면 그런 interceptors를 넣어주면됨
    ])
    
    let monitors = [ApiLogger()] as [EventMonitor]
    
    // 얘가 즉 Alamofire
    var session: Session
    
    init() {
        print("ApiClient - init() called")
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
}
 
