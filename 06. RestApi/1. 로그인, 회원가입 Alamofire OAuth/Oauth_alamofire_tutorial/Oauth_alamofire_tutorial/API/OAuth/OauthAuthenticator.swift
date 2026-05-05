//
//  OauthAuthenticator.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/22/25.
//

import Foundation
import Alamofire

final class OauthAuthenticator: Authenticator {

    // 헤더에 인증 추가
    func apply(_ credential: OAuthCredential, to urlRequest: inout URLRequest) {
        // 헤더에 Authrization 키로 bearer 토큰 값
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
        
        // 만약에 커스텀이면
        // urlRequest.headers.add(name: "ACCESS_TOKEN", value: "토큰값")
    }
    
    // 토큰 리프레시
    func refresh(_ credential: OAuthCredential,
                 for session: Session,
                 completion: @escaping (Result<OAuthCredential, Error>) -> Void) {
        
        print("OauthAuthenticator - refresh() called")
        
        // refresh_token이 비어있는지 확인
//        guard !credential.refreshToken.isEmpty else {
//            completion(.failure(AFError.invalidURL(url: ""))) // 적절한 에러 전달
//            return
//        }
        
        // 여기서 토큰 재발행 api 태우기
        // api를 태우는 도중에(life cycle이 끝나기전에 즉 Alamofire request session life cycle 끝나기 전에 살아있는거라서 이 session을 활용
        let request = session.request(AuthRouter.tokenRefresh)
        request.responseDecodable(of: TokenResponse.self) { result in
            switch result.result {
            // completion을 터트려야 여기서 머물지 않고 밖으로 나가게 된다
            case .success(let value):
                
                // MARK: - 재발행 받은 토큰 저장
                UserDefaultsManager.shared.setTokens(
                    accessToken: value.data.token.accessToken,
                    refreshToken: value.data.token.refreshToken)
                
                /// let expiration = Date(timeIntervalSinceNow: TimeInterval(value.data.token.expiresIn))
                let expiration = Date(timeIntervalSinceNow: 60*60)//////////////////////
                
                let newCredential = OAuthCredential(
                    accessToken: value.data.token.accessToken,
                    refreshToken: value.data.token.refreshToken,
                    expiration: expiration)
                
                completion(.success(newCredential))
                
            case .failure(let error):
                
                completion(.failure(error))
            }
        }
        
        // Refresh the credential using the refresh token...then call completion with the new credential.
        //
        // The new credential will automatically be stored within the `AuthenticationInterceptor`. Future requests will
        // be authenticated using the `apply(_:to:)` method using the new credential.
    }

    // api 요청 완료
    func didRequest(_ urlRequest: URLRequest,
                    with response: HTTPURLResponse,
                    failDueToAuthenticationError error: Error) -> Bool {
         
        print("OauthAuthenticator - didRequest() called")
        
        // accessToken이 완료되거나 accessToken이 refresh될때 여기서 처리됨
        // 401 코드가 떨어지면 refreshToken을 활용해서 accessToken을 재발행 하라고 요청
        switch response.statusCode {
        case 401:
            print("OauthAuthenticator - didRequest() returning true for 401 status code")
            return true
        default:
            print("OauthAuthenticator - didRequest() returning false for status code: \(response.statusCode)")
            return false
        }
        
        // If authentication server CANNOT invalidate credentials, return `false`
        // return false

        // If authentication server CAN invalidate credentials, then inspect the response matching against what the
        // authentication server returns as an authentication failure. This is generally a 401 along with a custom
        // header value.
        // return response.statusCode == 401
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: OAuthCredential) -> Bool {
        print("OauthAuthenticator - isRequest() returning true")
        return true

        // If authentication server CAN invalidate credentials, then compare the "Authorization" header value in the
        // `URLRequest` against the Bearer token generated with the access token of the `Credential`.
        // let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        // return urlRequest.headers["Authorization"] == bearerToken
    }
    
    
}
