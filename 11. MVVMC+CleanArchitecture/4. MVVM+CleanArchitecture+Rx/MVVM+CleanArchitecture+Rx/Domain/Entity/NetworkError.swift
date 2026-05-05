//
//  NetworkError.swift
//  MVVM+CleanArchitecture+Rx
//
//  Created by 김동현 on 4/3/25.
//

import Foundation

// MARK: - 네트워크 요청 오류
public enum NetworkError: Error {
    case urlError
    case invailedResponse      // 유효하지 않은
    case failToDecode(String)  // 디코딩 실패
    case dataNil
    case serverError(Int)      // 서버에서 던져주는 에러
    case requestFailed(String) // 특정 이유로 서버 요청 실패시
    
    public var description: String {
        switch self {
        case .urlError:
            "⚠️ URL이 올바르지 않습니다"
        case .invailedResponse:
            "⚠️ 응답값이 유효하지 않습니다"
        case .failToDecode(let description):
            "⚠️ 디코딩 에러: \(description)"
        case .dataNil:
            "⚠️ 데이터 가 없습니다"
        case .serverError(let statusCode):
            "⚠️ 서버에러: \(statusCode)"
        case .requestFailed(let message):
            "⚠️ 서버 요청 실패: \(message)"
        }
    }
}


