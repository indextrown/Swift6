//
//  enum.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/16/25.
//

import Foundation

// IntError열거형 정의
enum IntError: Error {
    case divisonByZero
}

// 안전한 나눗셈 함수 정의
func safeDivide(_ numerator: Int, _ denominator: Int) throws -> Int {
    
    // 0이면 에러 반환
    guard denominator != 0  else {
        throw IntError.divisonByZero
    }
    return numerator/denominator
}

@main
struct Main {
    static func main() {
        do {
            let result = try safeDivide(10, 0)
            print("Result: \(result)")
        } catch IntError.divisonByZero {
            // 0으로 나누는 경우 처리
            print("❌ Error: Cannot divide by zero.")
        } catch {
            // 기타 예상치 못한 에러 처리
            print("Unexpected error: \(error)")
        }
    }
}
