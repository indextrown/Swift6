//
//  ReplaceError.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/13/25.
//

// MARK: - 스트림 내에 에러가 발생했을 때, 대체 값을 제공하는 Publisher
import Combine


enum IntError: Error {
    case oddNumber
}
@main
struct Main {
    static func main() {
        
        var cancellable = Set<AnyCancellable>()
        
        let publisher = (0...2).publisher
        
        publisher.tryMap {
            if $0 % 2 == 0 {
                return $0
            } else {
                throw IntError.oddNumber
            }
        }
        .replaceError(with: nil)              // 에러가 발생시 에러를 던지는게 아니라 nil을 제공
        .sink { completion in
            switch completion {
            case .finished:
                print("끝: \(completion)")
            case .failure(let error):
                print("에러 발생: \(error)")    // .replaceError(with: nil)를 주석처리하면 발생
            }
        } receiveValue: { value in
            // 옵셔널 값이면 문자로 안전하게 처리
            print("\(String(describing: value))")
        }
        .store(in: &cancellable)
    }
}

/*
 결과
 Optional(0)
 nil
 끝: finished
 */
