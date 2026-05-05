//
//  UserApiService.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/22/25.
//

import Foundation
import Alamofire
import Combine

// 사용자 관련 api 호출
// 현재 사용자 정보, 모든 사용자 가져오기
enum UserApiService {
    
    // 현재 사용자 정보
    static func fetchCurrentUserInfo() -> AnyPublisher<UserData, AFError> {
        print("UserApiService - fetchCurrentUserInfo() called")
        
        // 저장된 토큰 데이터 가져오기
        let storedTokenData = UserDefaultsManager.shared.getTokens()
        
        // credential 생성
        let credential = OAuthCredential(
            accessToken: storedTokenData.accessToken,
            refreshToken: storedTokenData.refreshToken,
            expiration: Date(timeIntervalSinceNow: 60 * 60))
        
        // print("크리덴셜 accessToken - \(storedTokenData.accessToken)")
        // print("크리덴셜 refreshToken - \(storedTokenData.refreshToken)")
        
        // Create the interceptor
        let authenticator = OauthAuthenticator()
        let authInterceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
         
        return APiCient.shared.session
            .request(UserRouter.fetchCurrentUserInfo, interceptor: authInterceptor)
            
//            .responseData { response in
//                
//                // 응답 데이터 출력
//                if let data = response.data, let str = String(data: data, encoding: .utf8) {
//                    print("Response Data: \(str)")
//                }
//                if let error = response.error {
//                    print("Error: \(error)")
//                }
//            }
            
            .publishDecodable(type: UserInfoResponse.self)
            .value()
            .map { receivedValue in // 데이터 가공// 받은 토큰 정보 어딘가에 영구 저장 -> userdefaults(다음에 keychain으로 하자)
                return receivedValue.data.user
            }.eraseToAnyPublisher()
    }
    
    
    // 전체 사용자 정보
    static func fetchUsers() -> AnyPublisher<[UserData], AFError> {
        print("UserApiService - fetchUsers() called")
        
        // 저장된 토큰 데이터 가져오기
        let storedTokenData = UserDefaultsManager.shared.getTokens()
        
        // credential 생성
        let credential = OAuthCredential(
            accessToken: storedTokenData.accessToken,
            refreshToken: storedTokenData.refreshToken,
            expiration: Date(timeIntervalSinceNow: 60 * 60))
        
        // print("크리덴셜 accessToken - \(storedTokenData.accessToken)")
        // print("크리덴셜 refreshToken - \(storedTokenData.refreshToken)")
        
        // Create the interceptor
        let authenticator = OauthAuthenticator()
        let authInterceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
         
        return APiCient.shared.session
            .request(UserRouter.fetchUsers, interceptor: authInterceptor)
            
//            .responseData { response in
//
//                // 응답 데이터 출력
//                if let data = response.data, let str = String(data: data, encoding: .utf8) {
//                    print("Response Data: \(str)")
//                }
//                if let error = response.error {
//                    print("Error: \(error)")
//                }
//            }
            
            .publishDecodable(type: UserListResponse.self)
            .value()
            .map { receivedValue in // 데이터 가공// 받은 토큰 정보 어딘가에 영구 저장 -> userdefaults(다음에 keychain으로 하자)
                return receivedValue.data
            }.eraseToAnyPublisher()
    }
}
 
