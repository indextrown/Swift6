/*
 
 (180강)
 Async/await의 도입 / 스위프트 5.5이후
 - Async/await는 자바스크립트에서 있는 패턴을 스위프트에 도입한 개념이다
 
 비동기처리할때
 - 다른 스레드로 보낸다
 - 일을 시작시키고 즉시 리턴하기 때문에 함수 설계할 때 리턴형으로 설계하면 안된다
 - 리턴형이 아닌 클로저방식으로 설계하면 단점이 존재한다
 - 진행되는 작업이 다 끝난 시점에 함수를 실행시키는 개념이다
 
 단점:
 
 

 특징
 - 함수에 async를 붙혀주면 return 방식으로 설계할 수 있다
 */

import UIKit

// 불편함
func longtimePrint(completion: @escaping (Int) -> Void) {
    DispatchQueue.global().async {
        print("프린트 - 1")
        sleep(1)
        print("프린트 - 2")
        sleep(1)
        print("프린트 - 3")
        sleep(1)
        print("프린트 - 4")
        sleep(1)
        print("프린트 - 5")
        completion(7)
    }
}

// 비동기적인 함수를 실행하면 전달시 들여쓰기를 해야하게된다
func linkedPrint(completion: @escaping (Int) -> Void) {
    // 비동기적인 실행이 끝나면 num을 전달받고 ...
    longtimePrint { num in
        longtimePrint { num in
            longtimePrint { num in
                longtimePrint { num in
                    completion(num)
                }
            }
        }
    }
}


// MARK: ############## 새로운 방식 도입 ##############
// MARK: async 키워드 필수
func longTimeAsyncAwait() async -> Int {
    print("프린트 - 1")
    sleep(1)
    print("프린트 - 2")
    sleep(1)
    print("프린트 - 3")
    sleep(1)
    print("프린트 - 4")
    sleep(1)
    print("프린트 - 5")
    return 7
}

// MARK: 실행하는 쪽에서 await 키워드 필수
func linkedPrint2() async -> Int {
    _ = await longTimeAsyncAwait()
    _ = await longTimeAsyncAwait()
    _ = await longTimeAsyncAwait()
    _ = await longTimeAsyncAwait()
    return 7
}

// 비동기 함수는 Task 내에서 호출해야 함
Task {
    let result = await linkedPrint2()
    print("결과: \(result)")
}
