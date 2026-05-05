//
//  Filter.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/13/25.
//

// MARK: - Filter: 클로저의 조건과 일치하는 값을 발행하는 Publisher
import Combine

@main
struct Main {
    static func main() {
        
        // 1. 구독 저장소
        var cancellable = Set<AnyCancellable>()
        
        // 2. 퍼블리셔 생성
        let publisher = (0...6).publisher
        
        // 3. 짝수만 출력
        publisher.filter { $0 % 2 == 0 }
            .sink { completion in
                print("끝")
            } receiveValue: { value in
                print("\(value)")
            }
            .store(in: &cancellable)
    }
}

/*
 결과
 0
 2
 4
 6
 끝
 */
