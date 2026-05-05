//
//  UserSession.swift
//  MVVM+CleanArchitecture+Rx
//
//  Created by 김동현 on 4/4/25.
//

import Foundation
import Alamofire

// MARK: - 네트워크 호출 테스트코드 Mock Session(Fake) 추상화
// MARK: - 추상화를 통해 네트워크 호출 테스트코드 구현가능하도록 + 확장성 등
public protocol SessionProtocol {
    func request(_ convertible: URLConvertible,
                 method: HTTPMethod,
                 parameters: Parameters?,
                 headers: HTTPHeaders?) -> DataRequest
}

// Session
class UserSession: SessionProtocol {
    
    private var session: Session
    
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = Session(configuration: config)
    }
    
    func request(_ convertible: URLConvertible,
                 method: HTTPMethod = .get,
                 parameters: Parameters? = nil,
                 headers: HTTPHeaders? = nil) -> DataRequest {
        return session.request(convertible, method: method, parameters: parameters, headers: headers)
    }
}

class MockSession: SessionProtocol {
    
    private var session: Session
    
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = Session(configuration: config)
    }
    
    func request(_ convertible: URLConvertible,
                 method: HTTPMethod = .get,
                 parameters: Parameters? = nil,
                 headers: HTTPHeaders? = nil) -> DataRequest {
        return session.request(convertible, method: method, parameters: parameters, headers: headers)
    }
}
