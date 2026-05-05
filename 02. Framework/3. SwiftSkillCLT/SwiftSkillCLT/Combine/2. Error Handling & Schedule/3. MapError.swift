//
//  MapError.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/13/25.
//

// MARK: - Upstream Publisher에서 발생한 에러를 새로운 에러를 변환하는 Publisher
import Combine

enum IntError: Error {
    case oddNumber
}

enum CustomError: Error {
    case error(Error)
}

//@main
//struct Main {
//    static func main() {
//        let publisher = (0...2).publisher
//        
//        let intErrorPublisher = publisher.setFailureType(to: IntError.self)
//        
//        let customErrorPublisher = intErrorPublisher
//            .mapError { CustomError.error($0) }
//        
//        // MARK: - 이제 customErrorPublisher의 failure타입은 CustomError가 된다
//    }
//}

@main
struct Main {
    static func main() {
        
        var cancellables = Set<AnyCancellable>()
        let publisher = (0...2).publisher
        
        let _  = publisher
            .tryMap { value -> Int in
                if value % 2 == 0 {
                    return value
                } else {
                    throw IntError.oddNumber
                }
            }
            // 사용시 CustomError 타입
            // 주석시 IntError 타입
            .mapError { CustomError.error($0) } // CustomError 에러 변환
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("완료")
                    case .failure(let error):
                        print("에러 발생: \(error)")
                    }
                },
                receiveValue: { value in
                    print("값: \(value)")
                }
            )
            .store(in: &cancellables)
    }
}
