//
//  3.swift
//  Swift5
//
//  Created by 김동현 on 2/4/25.
//

import Combine

@main
struct Main {
    static func main() {
        var cancellables = Set<AnyCancellable>()
        
        let justPublisher = Just(100)
        
        let subscription = justPublisher.sink { completion in
            print("완료: \(completion)")
        } receiveValue: { value in
            print("받은 값: \(value)")
        }
    }
}
