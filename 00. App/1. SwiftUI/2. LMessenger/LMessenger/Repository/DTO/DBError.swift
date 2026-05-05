//
//  DBError.swift
//  LMessenger
//
//  Created by 김동현 on 1/15/25.
//

import Foundation

// DB Layer에서 다룰 수 있는 에러타입 추가
enum DBError: Error {
    case error(Error)
    case addUserError(Error)
    case getUserError(Error)
    case emptyValue
    case loadUserError(Error)
    case invalidatedType
    
        var errorDescription: String {
            switch self {
            case .addUserError(let underlyingError):
                return "❌ 에러 [addUser]: \(underlyingError.localizedDescription)"
            case .getUserError(let underlyingError):
                return "❌ 에러 [getUser]: \(underlyingError.localizedDescription)"
            case .emptyValue:
                return "❌ 에러 [emptyValue]"
            case .loadUserError(let underlyingError):
                return "❌ 에러 [loadUser]: \(underlyingError.localizedDescription)"
            case .invalidatedType:
                return "❌ 에러 [invalidatedType]"
            case .error(let error):
                return "❌ 에러 [error]: \(error)"
            }
        }
}

// 강의방식
//enum DBError: Error {
//    case error(Error)
//    case emptyValue
//    case invalidatedType
//}
