import UIKit

/*
 - 메서드의 헤드부분
 
 */

// 1) 정의
protocol RandomNumber {
    static func reset() // 최소한 타입 메서드가 되야함
    func random() -> Int
    mutating func doSomething()
}

// 2) 채택 / 3) 구현
class Number: RandomNumber {
    static func reset() {
        print("다시 세팅")
    }
    
    func random() -> Int {
        return Int.random(in: 1...100)
    }
    
    func doSomething() {
        
    }
}

// 2) 채택 / 3) 구현
// 구조체에서는 저장속성변경이 원래 허락되지 않음
// 저장속성을 메서드에서 바꿀 수 없다==> 이뮤터블
struct Number2: RandomNumber {
    var num = 0
    static func reset() {
        print("다시 세팅")
    }
    
    func random() -> Int {
        return Int.random(in: 1...100)
    }
    
    // 구조체에서는 저장속성을 메서드에서 바꾸는 것이 불가능함
    // 이유: 이뮤터블이라서
    // 그래서 mutating키워드를 붙여야 저장속성을 바꿀 수 있다
    mutating func doSomething() {
        self.num = 10
    }
}

// 1) 정의
protocol Togglable {
    // mutating의 키워드는 메서드 내에서 속성 변경의 의미일뿐(클래스에서 사용 가능)
    mutating func toggle()
}

// 2) 채택 / 3) 구현
// struct, 열거형은 값타입이라 자기자신 바꿀때 mutating qnxdudigka
enum OnOffSwitch: Togglable {
    case on
    case off
    
    mutating func toggle() {
        switch self {   // self가 on이면 나 자신을 off로 바꾼다
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}

var s = OnOffSwitch.off
s.toggle()
s.toggle()

// 2) 채택 / 3) 구현
class BigSwitch: Togglable {
    var isOn = false
    
    func toggle() {// mutating 키워드 필요없음(클래스이기때문)
        isOn = isOn ? false : true
    }
}

var big = BigSwitch()
big.toggle()
big.toggle()
