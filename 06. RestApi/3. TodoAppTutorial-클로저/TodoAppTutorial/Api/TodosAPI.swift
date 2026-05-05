//
//  TodosAPI.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 3/25/25.
//

import Foundation


// MARK: - Service Layer
enum TodosAPI {
    static let version = "v2"
#if DEBUG // 디버그
    static let baseURL = "https://phplaravel-574671-2962113.cloudwaysapps.com/api/" + version
#else     // 릴리즈
    static let baseURL = "https://phplaravel-574671-2962113.cloudwaysapps.com/api/" + version
#endif
    
    enum ApiError: Error {
        case parsingError
        case noContentError
        case jsonEncodingError
        case decodingError
        case badStatus(code: Int)
        case unknownError(_ error: Error?)
        case unAuthorized
        case nowAllowedUrl
        case errorResponseFromServer(_ errorResponse: ErrorResponse?)
        
        var info: String {
            switch self {
            case .noContentError: return "데이터가 없습니다"
            case .parsingError: return "파싱 에러입니다"
            case .jsonEncodingError: return "유효한 json 형식이 아닙니다"
            case .decodingError: return "디코딩 에러입니다"
            case .badStatus(code: let code): return "상태코드 에러입니다: \(code)"
            case .unknownError(let error): return "알 수 없는 에러입니다: \(error!)"
            case .unAuthorized: return "인증되지 않은 사용자입니다"
            case .nowAllowedUrl: return "올바른 URL 형식이 아닙니다"
            case .errorResponseFromServer(let errorResponse):
                return errorResponse?.message ?? "" 
            }
        }
    }
}
