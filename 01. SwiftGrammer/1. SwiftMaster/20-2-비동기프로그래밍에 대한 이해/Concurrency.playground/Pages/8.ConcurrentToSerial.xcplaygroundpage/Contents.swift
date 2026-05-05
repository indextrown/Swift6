//: [Previous](@previous)
import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

//: # 동시큐에서 직렬큐로 보내기
//: ### Thread-safe하지 않을때, 처리하는 방법
// 배열은 여러쓰레드에서 동시에 접근하면 문제가 생길 수 있다.

// 문자열 배열
// 빈문자열로 생성
var array = [String]()
print(array)

let serialQueue = DispatchQueue(label: "serial")

// MARK: 1부터 20까지 배열에 접근해서 출력 및 배열에 append도 가능
for i in 1...20 {
    // MARK: 배열은 메모리 공간에 하나만 존재하는데 여러 스레드에서 접근하고 있기 때문에 실제로
    DispatchQueue.global().async {
        //print("\(i)")
        //array.append("\(i)")    //  <===== 동시큐에서 실행하면 동시다발적으로 배열의 메모리에 접근
        
        // MARK: 비동기적으로 append하고 있어서 1부터 20까지의 비동기 처리를 할때 하나의 array메모리 공간에 동시에 접근하게됨
        // MARK: 전부 안들어갈수도 있음
        // MARK: 2번스레드에서 append할때 3번스레드에서도 동시에 append 즉 쓰기가 동시에 발생해서 thread safe하지 않은 상황 발생 가능
        
        // MARK: 직렬큐로 접근하기 때문에 한번에 하나의 일만 이 배열에 접근할 수 있다
        // MARK: thread safe하다-> 일반적으로 동시성문제 즉 경쟁상황을 해결하는 방법 중 하나이다
        serialQueue.async {        // 올바른 처리 ⭐️
            array.append("\(i)")
        }
    }
}




// 5초후에 배열 확인하고 싶은 코드 일뿐...

// MARK: asyncAfter = 비동기적으로 메인스레드에서 실행할건데 몇초 후에 실행해
DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    print(array)
    //PlaygroundPage.current.finishExecution()
}




//: [Next](@next)
//Copyright (c) 2021 we.love.code.allen@gmail.com
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
//distribute, sublicense, create a derivative work, and/or sell copies of the
//Software in any work that is designed, intended, or marketed for pedagogical or
//instructional purposes related to programming, coding, application development,
//or information technology.  Permission for such use, copying, modification,
//merger, publication, distribution, sublicensing, creation of derivative works,
//or sale is expressly withheld.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.
