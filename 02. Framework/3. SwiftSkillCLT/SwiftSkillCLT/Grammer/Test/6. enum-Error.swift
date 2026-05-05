//
//  enum.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/16/25.
//

import Foundation

// 하위 에러 열거형
enum DBError: Error {
    case connectionFailed(String)   // 연결 실패, 연관값으로 메시지 포함
    case queryFailed  // 쿼리 실패
    case wrappedError(Error)         // Swift Error 타입을 연관 값으로 추가
    
    // DBError 전용 처리 메서드
    func handle() {
        switch self {
        case .connectionFailed(let message):
            print("데이터베이스 연결 실패: \(message)")
        case .queryFailed:
            print("데이터베이스 쿼리 실패")
        case .wrappedError(let error):
            print("일반 에러 발생: \(error.localizedDescription)")
        }
    }
}

// 상위 에러 열거형
enum ServiceError: Error {
    case dbError(DBError)           // 연관값으로 DBError 포함
    case networkError(String)      // 네트워크 에런
    
    // ServiceError 전용 처리 메서드
    func handle() {
        switch self {
        case .dbError(let dbError):
            dbError.handle()
        case .networkError(let message):
            print("네트워크 에러: \(message)")
        }
    }
}


// 에러 발생 함수
func performDatabaseOperation() throws {
    throw ServiceError.dbError(.connectionFailed("데이터베이스에 연결할 수 없습니다"))
}

// 에러 처리 함수
func handleError(_ error: Error) {
    // ServiceError로 캐스팅 후 처리
    if let serviceError = error as? ServiceError {
        serviceError.handle()
    } else {
        print("알 수 없는 에러: \(error.localizedDescription)")
    }
}

@main
struct Main {
    static func main() {
        do {
            try performDatabaseOperation()
        } catch {
            handleError(error)
        }
    }
}
