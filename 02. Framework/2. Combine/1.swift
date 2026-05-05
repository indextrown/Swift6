//
//  1.swift
//  Swift5
//
//  Created by 김동현 on 2/4/25.
//

import Combine
import SwiftUI

func fetchData() -> Future<String, Error> {
    return Future { promise in
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            // let success = Bool.random()
            let success = false
            
            if success {
                promise(.success("데이터 가져오기 성공"))
            } else {
                promise(.failure(URLError(.badServerResponse)))
            }
        }
    }
}

@main
struct Main {
    static func main() {
        
        // AnyCancellable을 저장할 곳
        var cancellables = Set<AnyCancellable>()
        
        let cancellable: () = fetchData()
            .sink { completion in
                switch completion {
                case .finished:
                    print("스트림 완료")
                case .failure(let error):
                    print("에러 발생: \(error)")
                }
            } receiveValue: { value in
                print("받은 값: \(value)")
            }.store(in: &cancellables)
        
        // RunLoop를 사용해 비동기 작업 대기
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 5))
    }
}
