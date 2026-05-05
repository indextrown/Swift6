//
//  Catch.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/13/25.
//

// MARK: - Upstream Publisher에서 발생한 에러를 다른 Publisher로 대체하여 처리하는 Publisher
import Combine

enum IntError: Error {
    case oddNumber
}

@main
struct Main {
    static func main() {
        
        var cancellable = Set<AnyCancellable>()
        let publisher = (0...2).publisher
        
        publisher
            .tryMap {
                if $0 % 2 == 0 {
                    return $0
                } else {
                    throw IntError.oddNumber
                }
            }.catch { _ in
                return Just(nil)
            }.sink { completion in
                print("끝: \(completion)")
            } receiveValue: { value in
                print("\(String(describing: value))")
            }
            .store(in: &cancellable)
        
        print()
        publisher
        // MARK: - flatMap: upstream의 방출될 수 있는 값으로부터 새로운 publisher를 만든다
            .flatMap { intValue in
                Just(intValue)
                    .tryMap {
                        if $0 % 2 == 0 {
                            return $0
                        } else {
                            throw IntError.oddNumber
                        }
                    }
                    .catch { _ in
                        return Just(nil)
                    }
                }
            .sink { completion in
                print("끝: \(completion)")
            } receiveValue: { value in
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

 Optional(0)
 nil
 Optional(2)
 끝: finished

 2라는 값이 더 있는데 스트림이 끝났다.
 즉 catch를 사용하여도 발생한 에러에 대해서는 처리가 되지만 스트림이 종료된다.
 에러를 받고도 스트림을 유지하고싶다.
 
 해결책 - FlatMap
 
 */
