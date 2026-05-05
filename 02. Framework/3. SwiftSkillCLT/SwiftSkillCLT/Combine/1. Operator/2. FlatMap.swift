//
//  FlatMap.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/13/25.
//

// MARK: - FlatMap: Upstream Publisher에서 오는 값들을 새로운 Publisher로 변환하는 Publisher
import Combine

@main
struct Main {
    static func main() {
        
        // 1. 구독 저장소
        var cancellables = Set<AnyCancellable>()
        
        // 2. 퍼블리셔 생성
        let intPublisher = [1, 2, 3].publisher
        let stringPublisher = ["A", "B", "C"].publisher
        
        // 3. 퍼블리셔를 연결하여 새로운 퍼블리셔 생성
        intPublisher
            .flatMap { intValue in
                stringPublisher.map { "\(intValue)\($0)" }
            }.sink { value in   // 4. 구독 시작 및 결과 처리
                print("\(value)")
            }
            .store(in: &cancellables)
        
    }
}

/*
 결과
 1A
 1B
 1C
 2A
 2B
 2C
 3A
 3B
 3C
 */
