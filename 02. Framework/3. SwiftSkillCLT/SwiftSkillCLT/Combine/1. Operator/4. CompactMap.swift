//
//  CompactMap.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/13/25.
//

import Combine

@main
struct Main {
    static func main() {
        
        // 1. 구독 저장소
        var cancellable = Set<AnyCancellable>()
        
        // 2. 퍼블리셔 생성
        let publisher = [0, nil, 2].publisher
        
        // 3. nil이 아닌 값 발행
        publisher.compactMap { $0 }
            .sink { completion in
                print("종료: \(completion)")
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
 종료: finished
 */
