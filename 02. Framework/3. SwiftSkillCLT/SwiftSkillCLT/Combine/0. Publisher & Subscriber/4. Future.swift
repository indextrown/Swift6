//
//  3. Future.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/12/25.
//
//
//import Combine
//import Foundation
//
//@main
//struct Main {
//    static func main() {
//        let futurePublisher = Future<Int, Error> { promise in
//            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
//                    let result = 42 // 비동기 작업의 결과
//                    promise(.success(result)) // 성공적으로 값을 방출
//            }
//        }
//        
//        _ = futurePublisher
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    print("스트림 완료")
//                case .failure(let error):
//                    print("에러 발생: \(error.localizedDescription)")
//                }
//            } receiveValue: { value in
//                print("받은 값: \(value)")
//            }
//
//
//        // RunLoop를 사용해 비동기 작업 대기
//                RunLoop.main.run(until: Date(timeIntervalSinceNow: 2))
//    }
//}
//

// MARK: - Future: 한 번만 값을 방출하는 비동기 작업을 처리하기 위해 사용

import Combine
import Foundation

@main
struct Main {
    static func main() {
        
        // 1. 구독 저장소
        var cancellables = Set<AnyCancellable>()
        
        // 2. 비동기 작업을 수행하는 Future Publisher 생성
        let futurePublisher = Future<Int, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                let result = 42 // 비동기 작업 결과
                promise(.success(result)) // 성공적으로 값을 방출
            }
        }

        // 3. 구독 시작 및 결과 처리
        futurePublisher
            .sink { completion in
                switch completion {
                case .finished:
                    print("스트림 완료")
                case .failure(let error):
                    print("에러 발생: \(error.localizedDescription)")
                }
            } receiveValue: { value in
                print("받은 값: \(value)")
            }
            .store(in: &cancellables) // 구독 유지

        // RunLoop를 사용해 비동기 작업 대기
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 2))
    }
}

/*
 결과
 받은 값: 42
 스트림 완료
 */
