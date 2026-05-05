//
//  test.swift
//  Swift5
//
//  Created by 김동현 on 3/11/25.
//

//import Dispatch
//
//func test() async throws -> String {
//    try await Task.sleep(for: .seconds(2))
//    return "hello world"
//}
//
//@main
//struct Main {
//    static func main() {
//        
//        // DispatchSemaphore를 사용하여 메인 스레드가 비동기 작업이 완료될 때 까지 대기
//        let semaphore = DispatchSemaphore(value: 0)
//        
//        Task.detached {
//            let result = try await test()
//            print(result)
//            semaphore.signal()
//        }
//        
//        semaphore.wait()
//    }
//}


import Dispatch

func test1() async throws -> String {
    // (try?, throws제거) vs try 완전 다른방식으로 동작..
    // 취소가 될때 에러를 던지지 않는지(nil 리턴) vs 에러를 던지는지
    try await Task.sleep(for: .seconds(1))
    return "A"
}

func test2(string: String) async throws -> String {
    try await Task.sleep(for: .seconds(1))
    return string + " B"
}

func test3(string: String) async throws -> String {
    try await Task.sleep(for: .seconds(1))
    return string + " C"
}

func test4(string: String) async throws -> String {
    try await Task.sleep(for: .seconds(1))
    return string + " D"
}

func totalString() async throws -> String {
    // 무조건 순서대로 동작
    var result = try await test1()
    result = try await test2(string: result)
    result = try await test3(string: result)
    result = try await test4(string: result)
    return result
}

// 비동기 Task가 "메인 액터에서 실행된다"는 말은, 별도로 다른 액터나 스레드를 지정하지 않으면 그 Task가 생성된 환경(예: 메인 스레드)과 동일한 컨텍스트에서 실행된다
@main
struct Main {
    static func main() {
        
        // Task 내부의 비동기 코드가 백그라운드에서 실행되지만, main() 함수가 종료되면서 프로그램이 바로 종료되기 때문
        // DispatchSemaphore를 사용하여 메인 스레드가 비동기 작업이 완료될 때 까지 대기
        let semaphore = DispatchSemaphore(value: 0)
        
        Task.detached {
            
            let result = try await totalString()
            print(result)
            semaphore.signal()
        }
        
        semaphore.wait() // 메인 스레드가 semaphore.wait()에서 대기, semaphore.signal()이 호출되면 프로그램이 계속 진행
    }
}


