/*
 
 (120강)
 
 소급 모델링
 - 이미 애플이 구현한것 ex) Int, String은 건들 수 없기 때문에 소급해서 적용할 수 있도록 확장에서는 구현 가능하다
 */

// 타입 계산속성의 확장
// 타입속성: 붕어빵틀에속해있는것
// 메모리구조가 실제 인스턴스와 다르게 데이터 영역에 있는 붕어빵 틀과 관련된 속성
// static을 붙이면 타입속성이 된다
extension Double {
    // 타입 계산ㄴ속성
    static var zero: Double {
        return 0.0
    }
}
Double.zero




// 인스턴스 계산 속성의 확장
extension Double {
    var km: Double {
        return self * 1_000.0
    } // 인스턴스 자신에 1000 곱하기
    var m: Double {
        return self
    }
    
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}

// self는 미터 기준으로 구현
10.0.km     // 10,000m
10.0.cm     // 0.1m

let oneInch = 25.4.mm
print("1인치는 \(oneInch) 미터 ")        // 1인치는 0.0254미터

let threeFeet = 3.ft
print("3피트는 \(threeFeet) 미터 ")      // 3피트는 0.914399970739201 미터

let aMaraton = 42.km + 195.m
print("마라톤은 \(aMaraton) 미터의 길이임") // 마라톤은 42195.0 미터의 길이임

// 편한 방법
extension Int {
    var squared: Int {
        return self * self
    }
}

// 불편한 방법
func squared(num: Int) -> Int {
    return num * num
}


// 애플이 만든 타입 메서드 예시
Int.random(in: 1...100)

// 타입 메서드의 확장
extension Int {
    static func printNumberFrom1to5() {
        for i in 1...5 {
            print(i)
        }
    }
}
Int.printNumberFrom1to5()


// 인스턴스 메서드의 확장
// 장점: 문자열 자체를 건들 수 없지만 확장기능을 통해 추가 가능
// 소급 모델링:
extension String {
    func printHelloRepetitions(of times: Int) {
        for _ in 0..<times {
            print("Hello \(self)!")
        }
    }
}

"Steve".printHelloRepetitions(of: 4)
"Swift".printHelloRepetitions(of: 5)

/*
- mutating 인스턴스 메서드의 확장
- 구조체나 열거형처럼 값타입일때 사용
- 메서드에서 원칙적으로 저장속성을 바꿀 수 없는데 구조체, 열거형에서 자신의 속성을 변경할 경우 mutating 키워드 필요
 
 - 구조체나 열거형에서 값을 직접적으로 바꿀때 사용한다
*/

extension Int {
    mutating func square() {
        self = self * self
    }
}

var someInt = 3
someInt.square()
