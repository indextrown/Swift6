//
//  Fail.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/13/25.
//

import Combine
import Foundation

// 1. 커스텀 에러 정의
enum IntError: Error {
    case sampleError
}

@main
struct Main {
    static func main() {
        
        // 1. 구독 저장소
        var cancellables = Set<AnyCancellable>()
        
        // 2. Fail Publisher 생성
        let failPublisher = Fail<Int, IntError>(error: .sampleError)
        
        // 3. 구독 및 결과 처리
        let cancellable = failPublisher
            .sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Received finished.")
                case .failure(let error):
                    print("Received failure(항상 발생):", error)
                }
            },
            receiveValue: { value in
                print("Received value:", value)
            }
        )
        
        // 4. 구독 저장
        cancellable.store(in: &cancellables)
        
        ㄹ
    }
}

/*
 결과
 Received failure(항상 발생): sampleError
 */
