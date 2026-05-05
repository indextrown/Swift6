import UIKit

// 타입의 확장-새로운 중첩 타입 정의 및 사용

class Day {
    enum WeekDay {
        case mon
        case tue
        case wed
    }
    var day: WeekDay = .mon
}

// WeekDay는 Day라는 클래스 내부에서만 쓰이는 열거형이다
// 타입 안에 타입을 정의할 수 있다
var ddd: Day.WeekDay = Day.WeekDay.mon





//
extension Int {
    enum Kind {
        case negative, zero, positive
    }
    
    // 계산속성 정의
    var kind: Kind {
        // self = 정수형의 인스턴스
        switch  self {
        case 0:
            return Kind.zero
        case let x where x > 0: // let x에 바인딩: 조건으로 x가 0보다 크다면 즉 양수인 경우
            return .positive
        default:
            return Kind.negative
        }
    }
}

let a: Int = 1
a.kind

let b: Int = 0
b.kind

let c = -1
c.kind

var f = Int.Kind.positive

Int.Kind.negative
Int.Kind.positive
Int.Kind.zero

let d: Int.Kind = Int.Kind.negative
let dd =  Int.Kind.negative


func printIntegerKinds(_ numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .negative:
            print("- ", terminator: "")
        case .zero:
            print("0 ", terminator: "")
        case .positive:
            print("+ ", terminator: "")
        }
    }
    print("")
}

printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
