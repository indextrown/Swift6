//
//  UserRouter.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/22/25.
//

import Foundation
import Alamofire

// 사용자 라우터
// 현재 로그인한 사용자 정보, 모든 사용자 가져오기
enum UserRouter: URLRequestConvertible {
    
    case fetchCurrentUserInfo
    case fetchUsers
    
    var baseURL: URL {
        return URL(string: APiCient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .fetchCurrentUserInfo:
            return "user/info"
        case .fetchUsers:
            return "user/all"
        }
    }
    
    // 어떠한 api를 태우느냐에 따라 설정 -> 디폴트 get 설정
    var method: HTTPMethod {
        switch self {
        default: return .get
        }
    }
    
    // 파라미터(없으므로 default로 지정)
    var parameters: Parameters{
        switch self {
        default:
            return Parameters()
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        var request = URLRequest(url: url)
        request.method = method
        return request
    }
}
