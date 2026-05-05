//
//  main.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/12/25.
//

import Combine

@main
struct Main {
    static func main() {
        
        // 1. 100을 방출하고 종료되는 퍼블리셔
        let intPublisher = Just(100)
        
        // 2. 구독 시작
        let cancellable = intPublisher.sink { completion in
            print("Received completion: \(completion)")
        } receiveValue: { value in
            print("Received value: \(value)")
        }
    }
}



/*
 결과
 Received value: 100
 Received completion: finished
 */
