//
//  TryMap.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/13/25.
//

// MARK: - TryMap: Map과 유사하지만 transform 클로저에서 에러를 throw할 수 있는 Publisher
import Combine

enum IntError: Error {
    case oddNumber // 홀수
}

@main
struct Main {
    static func main() {
        
        // 1. 구독 저장소
        var cancellables = Set<AnyCancellable>()
        
        // 2. 0부터 2까지 방출하는 퍼블리셔 생성
        let publisher = (0...2).publisher
        
        // 3. 홀수이면 에러 방출
        publisher.tryMap {
            if $0 % 2 == 0 {
                return $0
            } else {
                throw IntError.oddNumber
            }
        }
        // 4. 구독 시작 및 결과 처리
        .sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Received finished.")
                case .failure(let error):
                    print("Received failure: \(error)")
                }
            },
            receiveValue: { value in
                print("Received value: \(value)")
            })
        .store(in: &cancellables)
    }
}

/*
 결과
 Received value: 0
 Received failure: oddNumber
 */
