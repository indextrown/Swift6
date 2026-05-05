//
//  Type Erase.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/13/25.
//

// MARK: - eraseToAnyPublisher: 원래의 Publisher타입을 지우고 AnyPublisher로 반환
// 실제 Publisher타입 정보가 감춰져 다양한 유형의 Publisher 처리 및 반환 가능
import Combine

@main
struct Main {
    static func main() {
        // Step 1: 원래 Publisher를 생성
        let intPublisher = [1, 2, 3, 4, 5].publisher
            .map { $0 * 2 } // 2배로 변환
            .filter { $0 % 3 == 0 } // 3의 배수만 필터링
        
        // Step 2: AnyPublisher로 변환
        let anyIntPublisher: AnyPublisher<Int, Never> = intPublisher
            .eraseToAnyPublisher()

        // Step 3: 구독 및 출력 확인
        let cancellable = anyIntPublisher.sink { value in
            print("받은 값: \(value)")
        }
    }
}

/*
 받은 값: 6
 */
