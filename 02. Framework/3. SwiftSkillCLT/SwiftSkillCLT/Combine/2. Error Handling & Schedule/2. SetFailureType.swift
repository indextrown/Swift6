//
//  2. SetFailureType.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/13/25.
//

// MARK: - Publisher의 Failure 타입을 변형하는데 사용되는 Publisher
import Combine

enum IntError: Error {
    case error
}
@main
struct Main {
    static func main() {
        
        var cancellables = Set<AnyCancellable>()
        let publisher = (0...2).publisher
        
        // MARK: - Failer타입을 IntError로 설정
        // 이 연산자는 Publisher들이 failure타입이 일치하지 않을 경우 일치시키고 통합된 에러처리를 수행할 수 있게 해준다
        let intErrorPublisher = publisher.setFailureType(to: IntError.self)
    }
}
