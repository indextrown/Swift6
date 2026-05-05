//
//  AuthApiService.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/21/25.
//

import Foundation
import Alamofire
import Combine

// 인증 관련 api 호출
enum AuthApiService {
    
    // 회원가입
    static func register(name: String, email: String, password: String) -> AnyPublisher<UserData, AFError> {
        print("AuthApiService - register() called")
        return APiCient.shared.session
            .request(AuthRouter.register(name: name, email: email, password: password))
            /*
            .responseData { response in
                // 응답 데이터 출력
                if let data = response.data, let str = String(data: data, encoding: .utf8) {
                    print("Response Data: \(str)")
                }
                if let error = response.error {
                    print("Error: \(error)")
                }
            }
            */
            .publishDecodable(type: AuthResponse.self)
            .value()
            .map { receivedValue in // 데이터 가공// 받은 토큰 정보 어딘가에 영구 저장 -> userdefaults(다음에 keychain으로 하자)
                UserDefaultsManager.shared.setTokens(
                    accessToken: receivedValue.data.token.accessToken,
                    refreshToken: receivedValue.data.token.refreshToken)
                return receivedValue.data.user
            }.eraseToAnyPublisher()
    }
    
    // 로그인
    static func login(email: String, password: String) -> AnyPublisher<UserData, AFError> {
        print("AuthApiService - login() called")
        return APiCient.shared.session
            .request(AuthRouter.login(email: email, password: password))
            /*
            .responseData { response in
                // 응답 데이터 출력
                if let data = response.data, let str = String(data: data, encoding: .utf8) {
                    print("Response Data: \(str)")
                }
                if let error = response.error {
                    print("Error: \(error)")
                }
            }
             */
            .publishDecodable(type: AuthResponse.self)
            .value()
            .map { receivedValue in // 데이터 가공
                // 받은 토큰 정보 어딘가에 영구 저장 -> userdefaults(다음에 keychain으로 하자)
                UserDefaultsManager.shared.setTokens(
                    accessToken: receivedValue.data.token.accessToken,
                    refreshToken: receivedValue.data.token.refreshToken)
                // print("로그인 성공 accessToken - \(receivedValue.data.token.accessToken)")
                // print("로그인 성공 refreshToken - \(receivedValue.data.token.refreshToken)")
                return receivedValue.data.user
            }.eraseToAnyPublisher()
    }
}
 
