//
//  ServiceError.swift
//  LMessenger
//
//  Created by 김동현 on 1/13/25.
//

import Foundation

// 서비스 layer에서 다루는 에러 타입
/*
 dbError(DBError):
 데이터베이스 계층에서 발생한 에러(DBError)를 포함합니다.
 예를 들어, addUserError가 발생하면 이를 서비스 계층에서 dbError로 감쌉니다.
 error(Error):
 서비스 계층에서 발생한 일반적인 에러를 포함합니다.
 Swift의 Error 타입을 직접 포장하여 다른 계층의 에러도 처리할 수 있습니다.
 DBError는 데이터베이스 관련 에러를 정의하며, 서비스 계층으로 전달됩니다.
 ServiceError는 여러 계층의 에러를 통합하여 관리하고, 서비스 로직에서 발생한 에러를 처리합니다.
 */
/*
 error는 열거형의 한 케이스입니다.
 연관 값을 사용하여 **다른 오류 타입(Error)**을 감쌉니다.
 즉, 이미 존재하는 오류 타입을 포장(wrapper)하여 다룰 수 있습니다.
 */
enum ServiceError: Error {
    
    case dbError(DBError) // DBError를 포함
    case error(Error)
    
//    var errorDescription: String {
//        switch self {
//        case .dbError(let dbError):
//            return dbError.errorDescription
//        case .error(let error):
//            return error.localizedDescription
//        }
//    }
}


