//
//  Try.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/14/25.
//

/*
 
 try
 - 예외 사항 다루기 위한 방법의 do try catch문을 사용
 - do문 내에서 try한 메서드에 에러가 발생하면 앱이 종료되지 않고 catch문에서 처리한다
 
 try?
 - 에러 발생시 nil 반환
 - 에러 발생하지 않으면 반환 타입은 Optional이다
 - 반환 타입이 없어도 사용 가능하다.
 do-catch문 없이 사용 가능하다
 
 try!
 - 에러 발생 시 Crash 발생
 - 반환 타입은 언래핑(Non-Optional)
 - 에러가 발생하지 않는다는 것을 보장하고 해당 함수를 호출하는 것이다
 
 */

// MARK: - 커스텀 에러 타입 정의
enum MathError: Error {
    case divisionByZero // 0으로 나누는 경우 에러
}

// 나눗셈 연산 함수(에러 발생 가능)
func divide(_ numerator: Int, by denominator: Int) throws -> Int {
    // 0으로 나누는 경우 에러 발생
    if denominator == 0 {
        throw MathError.divisionByZero
    }
    // 나눗셈 결과 반환
    return numerator/denominator
}

@main
struct Main {
    static func main() {
        
        // MARK: - 일반적인 에러 처리
        do {
            let result = try divide(10, by: 2)
            print("try 사용 결과: \(result)") // 출력: 5
        } catch {
            print("에러 발생")
        }
        
        // MARK: - try?: 에러 발생 시 nil 반환
        let optionalResult = try? divide(10, by: 0)
        print("try? 사용 결과: \(String(describing: optionalResult))") // 출력: nil
        
        // MARK: - try!: 에러 발생 시 Crash
        let forceResult = try! divide(10, by: 2) // 10 나누기 2
        print("try! 사용 결과: \(forceResult)") // 출력: 5
        
        // 주석 처리된 코드는 Crash를 방지하기 위해 실행하지 않음
        // let crashResult = try! divide(10, by: 0) // 10 나누기 0 -> Crash
        
    }
}
