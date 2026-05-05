//
//  4. Task.swift
//  Swift5
//
//  Created by 김동현 on 2/5/25.
//

import Foundation

@main
struct Main {
    static func main() {
        
        // 1. - 기존 동시성 프로그래밍(GCD) (대기열 / 큐를 사용)
        // 기존 방시: 대기열에 넣어서 2번 cpu에 일을 시키는 방식으로 비동기 처리..GCD
        // ------------------------------------------------------------------------------------
        let group = DispatchGroup()
        group.enter() // 그룹에 작업 추가
        
        // 기존 동시성 프로그래밍(GCD)
        // 기본적으로 다른 쓰레드로 보내지 않았다면 1번 쓰레드에서 실행한다
        print("메인 쓰레드에서 실행 - 1")
        print("메인 쓰레드에서 실행 - 2")

        // 무조건 2번(또는 특정의 백그라운드) 스레드로 보내서 실행하겠다는 의미 (클로저 내에서는 순차)
        DispatchQueue.global().async {
            defer { group.leave() } // 작업 완료 후 그룹에서 제거
            print("백그라운드 쓰레드에서 실행 - 1")
            print("백그라운드 쓰레드에서 실행 - 2")
        }

        print("메인 쓰레드에서 실행 - 3")
        print("메인 쓰레드에서 실행 - 4")
        
        group.wait()
        
        
        
        // 2. Swift Concurrency(async/await/task)

        // (비동기적인 일처리를 할 수 있게 만들어주는) 비동기적인 실행 작업 단위룰 만드는 것 => Task 클로저 내부에서 비동기적인 일을 수행가능 ⭐️
        // Task (작업) - 비동기적인 일처리를 할 수 있는 하나의 실행 작업 단위를 만드는 것
        /// 구조체로 만들어진
        /// A unit of asynchronous work.
        /// (프로그램의 일부로써) 비동기적으로 (실행될 수 있는 하나의) 작업 단위 - "비동기적인 일처리를 할 수 있는 하나의 작업 단위"
        // https://developer.apple.com/documentation/swift/task


        /// 비동기 실행 컨텍스트(비동기함수가 실행될 수 있는 실행 환경)를 만드는 것이기도 함
        /// Swift Concurrency에서 작업(Task)은 기본 단위임.
        /// (내부에서 동시성 코드를 실행하고 그 상태와 관련 데이터를 관리)



        /// Task방식은 트레일링 클로저 형태로 사용 / 작업 클로저를 생성하자마자, 작업 즉시 실행
        /// 작업을 변수에 담는 것도 가능
        /// (필요한 경우에 변수에 담아서 사용)
        // Task(priority: <#T##TaskPriority?#>, operation: <#T##() async -> Sendable#>)
        // Task(priority: <#T##TaskPriority?#>, operation: <#T##() async throws -> Sendable#>)
        // ------------------------------------------------------------------------------------
        
        // MARK: - 지금은 GCD랑 비슷함
        // 메인 스레드가 아닌 2번cpu 혹은 다른cpu 에서 일을 시킬 수 있다
        
        // 2번 cpu에서 일을 시킬 수 있다
        Task {
            // 스코프 내부에서는 순차적 실행이 된다!!!
            print("비동기적인 일 - 1")
            print("비동기적인 일 - 2")
        }
        
        // 3번 cpu에서 일을 시킬 수 있다
        Task {
            // try await Task.sleep(for: .seconds(3))
            print("비동기적인 일 - 5")
            print("비동기적인 일 - 6")
        }
        // -> 2번, 3번 병렬적으로 동시에 일을 할 수 있게 만들어준다
        
        // task를 변수에 담을 수 있다
        // 변수에 담으면 cancel 메서드 사용 가능
        // Never: 일반적인 구조에서 에러 발생하지 않는다
        let task: Task<Void, Never> = Task {
            print("비동기적인 일 - 7")
            print("비동기적인 일 - 8")
        }
        task.cancel()
        
        // task 작업의 결과로 문자열 리턴 가능
        let task2: Task<String, Never> = Task {
            print("비동기적인 일 - 9")
            print("비동기적인 일 - 10")
            return "문자열"
        }
        
        func doSomething2() {
            print("함수 내부의 동기적인 실행 - 1")
            Task {
                try await Task.sleep(for: .seconds(2))
                print("함수 내부의 오래걸리는 일")
            }
            
            print("함수 내부의 동기적인 실행 - 2")
        }
        
        doSomething2()
        
        /// 작업 실행 우선 순위의 종류
        /// ===============================
        /// TaskPriority.userInitiated - 25
        /// TaskPriority.high - 25
        /// TaskPriority.medium - 21
        /// TaskPriority.low - 17
        /// TaskPriority.utility - 17
        /// TaskPriority.background - 9
        /// ===============================

        
        
        
    }
}


