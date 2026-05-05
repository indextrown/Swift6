//
//  AuthRouter.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/21/25.
//

import Foundation
import Alamofire

// 인증 라우터
// 회원가입, 로그인, 토큰갱신
enum AuthRouter: URLRequestConvertible {
    
    case register(name: String, email: String, password: String)
    case login(email: String, password: String)
    case tokenRefresh
    
    var baseURL: URL {
        return URL(string: APiCient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .register:
            return "user/register"
        case .login:
            return "user/login"
        case .tokenRefresh:
            return "user/token-refresh"
        }
    }
    
    // 어떠한 api를 태우느냐에 따라 설정 -> 디폴트 post 설정
    var method: HTTPMethod {
        switch self {
        default: return .post
        }
    }
    
    // 파라미터
    var parameters: Parameters{
        switch self {
        case let .login(email, password):
            var params = Parameters()
            params["email"] = email
            params["password"] = password
            return params
            
        case .register(let name, let email, let password):
            var params = Parameters()
            params["name"] = name
            params["email"] = email
            params["password"] = password
            return params
            
        case .tokenRefresh:
            var params = Parameters()
            let tokenData = UserDefaultsManager.shared.getTokens()
            params["refresh_token"] = tokenData.refreshToken
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        var request = URLRequest(url: url)
        request.method = method
        
        // 요청 정보 출력
        print("Request URL: \(url)")
        print("Request Parameters: \(parameters)")
        
        request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        return request
    }
}
