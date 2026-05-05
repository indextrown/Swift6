//
//  5. enum-Error.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/16/25.
//

import Foundation

// 하위 에러 열거형
enum DBError: Error {
    case connectionFailed(String)   // 연결 실패, 연관값으로 메시지 포함
    case queryFailed  // 쿼리 실패
}

// 상위 에러 열거형
enum ServiceError: Error {
    case dbError(DBError)           // 연관값으로 DBError 포함
    case networkError(String)      // 네트워크 에런
}

// 일부러 에러 발생하는 함수
func performDatabaseOperation() throws {
    throw ServiceError.dbError(.connectionFailed("데이터베이스에 연결할 수 없습니다"))
}

// 에러 처리 함수
func handleError(_ error: Error) {
    // 에러를 ServiceError로 처리
    // as?: 옵셔널 다운캐스팅 연산자
    // error가 ServiceError 타입으로 변환 가능한지 확인하고 성공시 serviceError에 값 저장 실패시 nil
    if let serviceError = error as? ServiceError {
        // serviceError는 이제 ServiceError 타입
            switch serviceError {
            case ServiceError.dbError(let dbError):
                switch dbError {
                case DBError.connectionFailed(let message):
                    print("데이터베이스 연결 실패: \(message)")
                case DBError.queryFailed:
                    print("데이터베이스 쿼리 실패")
                }
            case ServiceError.networkError(let message):    // ServiceError의 networkError 처리
                print("네트워크 에러: \(message)")
            }
    }
}

@main
struct Main {
    static func main() {
        // 테스트 실행
        do {
            try performDatabaseOperation()
        } catch {
            handleError(error)
        }
    }
}
