//
//  BaseInterceptor.swift
//  MeowGallery
//
//  Created by 김동현 on 3/22/25.
//

import Foundation
import Alamofire

final class BaseInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        
        var request = urlRequest
        let API_KEY = Bundle.main.infoDictionary?["API_KEY"] ?? "None"
        
        // 헤더 부분 넣어주기
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue(API_KEY as! String, forHTTPHeaderField: "x-api-key")
        completion(.success(request))
    }
}
