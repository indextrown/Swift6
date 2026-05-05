//
//  2. Empty.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/12/25.
//

/*
 MARK: Empty
 - 값을 생성하지 않고 완료만 하는 Publisher
 
 */
import Combine

@main
struct Main {
    static func main() {
        
        // 1. 퍼블리셔 생성
        let emptyPublisher = Empty<Int, Never>()
        
        // 2. 구독 시작
        _ = emptyPublisher
            .sink { completion in
                switch completion {
                case .finished:
                    print("Received finished")
                //case .failure(let error):
                  //  print("Received failure: \(error.localizedDescription)")
                }
            } receiveValue: { value in
                print("Received value: \(value)")
            }
    }
}

/*
 결과
 Received finished
 */
