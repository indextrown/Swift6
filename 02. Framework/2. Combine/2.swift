//
//  2.swift
//  Swift5
//
//  Created by 김동현 on 2/4/25.
//

import Combine

enum MyError: Error {
    case testError
}

@main
struct Main {
    static func main() {
        // AnyCancellable을 저장할 곳
        var cancellables = Set<AnyCancellable>()
        
        // 퍼블리셔
        let publisher = Fail<Int, MyError>(error: .testError)
        
        publisher
            .sink { completion in
                switch completion {
                case .finished:
                    print("스트림 완료")
                case .failure(let error):
                    print("스트림 에러 발생: \(error)")
                }
            } receiveValue: { value in
                print("받은 값: \(value)")
            }
            .store(in: &cancellables)

    }
}
