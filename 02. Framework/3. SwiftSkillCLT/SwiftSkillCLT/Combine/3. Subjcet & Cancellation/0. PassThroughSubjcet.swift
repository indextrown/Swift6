//
//  PassThroughSubjcet.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/13/25.
//

// MARK: - Subject: Publisher, Subscriber 두 역할 모두 가능
// MARK: - PassthroughSubjcet: 방출된 값과 이벤트들을 전달만 하는 역할
import Combine

@main
struct Main {
    static func main() {
        
        var cancellable = Set<AnyCancellable>()
        
        // 1. 퍼블리셔 생성
        let publisher = (0...2).publisher
        
        // 2. Subjcet 구독역할
        let subscriber = PassthroughSubject<Int, Never>()
        publisher.subscribe(subscriber)
            .store(in: &cancellable)
        
        
        var cancellable2 = Set<AnyCancellable>()
        
        // 1. 퍼블리셔 역할
        let publisher2 = PassthroughSubject<Int, Never>()
        
        // 2. 구독
        publisher2.sink { value in
            print("\(value)")
        }
        .store(in: &cancellable2)
        
    }
}
