//
//  Map.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/13/25.
//

// MARK: - Map: transform 클로저를 사용하여 Upstream Publisher에서 나오는 모든 값들을 변환하는 Publisher
import Combine

@main
struct Main {
    static func main() {
        
        
        // 1. 구독 저장소
        var cancellables = Set<AnyCancellable>()
        
        // 2. 1부터 3까지 방출하는 퍼블리셔 생성
        let publisher = (1...3).publisher
        
        // 3. mapPublisher에 업스트림으로 퍼블리셔 전달
        // transform 클로저에 업스트림의 값들에 곱하기 10을 해서 반환해준다
        let mapPublisher = Publishers.Map(upstream: publisher) { $0 * 10}
        
        // 4. 구독 시작 및 결과 처리
        mapPublisher.sink { value in
            print("Received Value: \(value)")
        }
        .store(in: &cancellables)
        
        
        // MARK: - 간단한 방식
        (4...6).publisher
            .map { $0 * 10 }
            .sink { value in
                print("Received Value: \(value)")
            }
            .store(in: &cancellables)
    }
}

/*
 결과
 Received Value: 10
 Received Value: 20
 Received Value: 30
 Received Value: 40
 Received Value: 50
 Received Value: 60
 */
