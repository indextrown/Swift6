//
//  Zip.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/13/25.
//

// MARK: - Zip: 두 개 이상의 Upstream Publisher로부터 나온 값을 받아와 조합하고 그 값을 방출해주는 Publisher
import Combine

@main
struct Main {
    static func main() {
        
        // 1. 구독 저장소
        var cancellable = Set<AnyCancellable>()
        
        // 2. 퍼블리셔 생성
        let publisher1 = [1, 2, 3].publisher
        let publisher2 = ["A", "B", "C"].publisher
        
        // 3. 조합하여 구독자에게 발행
        Publishers.Zip(publisher1, publisher2)
            .sink { completion in
                print("종료: \(completion)")
            } receiveValue: { value in
                print("\(value)")
            }
            .store(in: &cancellable)
    }
}
