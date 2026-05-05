//
//  BaseInterceptor.swift
//  Oauth_alamofire_tutorial
//
//  Created by 김동현 on 3/21/25.
//

import Foundation
import Alamofire

// API 호출시 중간에 뭔가를 넣어준다
final class BaseInterceptor: RequestInterceptor {
    
    // API 호출시 중간에 처리핸들을 해준다
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        
        var request = urlRequest
        
        // 헤더 부분 넣어주기
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
            
        // completion으로 터트려줘야 API가 제대로 통과된다
        completion(.success(request))
    }
    
    
}
