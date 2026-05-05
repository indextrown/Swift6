import UIKit

/*
 (150강)
 map함수
 배열이 있을떄 하나하나의 아이템을 꺼내서 매핑을 해주는 함수가 map이다
 
 
 클로저 팁
 - 클로저에서 퍼라미터를 생략할 수 있다, in도 생략해야한다 그 대신에 첫번째 파라미터라는 의미에서 $0을 쓸 수 있다
 - 클로저가 한줄이면 return도 생략 가능하다
 
 어떠한 배열이든 map가능
 
 고차함수
 - Sequence, Collection 프로토콜을 따르는 컬렉션(배열, 딕셔너리, 세트 등)에 기본적으로 구현되어 있는 함수
 - Optional타입에도 구현되어 있음
 - 왜 자주쓰일까?
 서버에서 데이터 받아올때
 for문으로 받아오는것은 저차원적인 방법
 map으로 데이터를 쉽게 변형할 수 있다
 
 */


let numbers = [1, 2, 3, 4, 5]

// 정수형이 input이고 아웃풋이 T라는 함수를 파라미터로 사용하고 있는 함수를 map이라고 한다
// T는 어떠한 타입으로도 변형가능한 타입으로 인식하자
// input이 정수형이고 output은 어떠한 타입도 괜찮다 라는 함수이다
// numbers.map(<#T##transform: (Int) throws -> T##(Int) throws -> T#>)

// 클로저 라는 것
// 함수에는 클로저를 사용해도 된다
// 클로저를 통해서 정수타입을 받아서 문자열로 바꾸는 상황
// (Int) -> String
var aaa: [String] = numbers.map { num in     // num: 정수형
    return "숫자: \(num)" // 문자열로 바뀌고 있다 == 변형하는 방법을 제시했다
}

// 기존의 정수를 보유한 [1, 2, 3, 4, 5] 배열이 아래처럼 바뀌었다
// "["숫자: 1", "숫자: 2", "숫자: 3", "숫자: 4", "숫자: 5"]\n"
print(aaa)


// 정수를 꺼내서 클로저에서 변형시켜서 문자열로 꺼내준다
// 결과적으로 하나하나씩 리턴한 요소들을  묶어서 배열로 리턴하게 된다




// numbers라는 변수에 배열이 들어있다
let numbers2 = [1, 2, 3, 4, 5]

// numbers.을 붙이면 map이라는 애플이 미리 구현해둔 함수가 있다

// 이는 배열에 들어있는 아이템을 하나하나꺼내서 매핑 후 새롭게 배열을 만들어주는 함수이다

// 매핑하는 방식: 뭘로 매핑할거냐, 뭘로 변형을 할거냐 방법을 제공해줘야된다 ==> 방법제시 방법이 클로저이다

// map는 input파라미터로 함수(클로저)를 요구한다

// 어떤 함수냐면 input이 정수형이고 output이 어떤 타입이든 가능한 함수이다

// 그 함수를 직접적으로 구현한것이다

// 정수를 num으로 받아서 문자열로 변환해서 리턴해주겠습니다... 이건 클로저다 이 클로저를 Input으로 사용한거다

//num in     // num: 정수형
//    return "숫자: \(num)"

// 변환되어 반환된 요소들을 묶어서 배열로 리턴하게 된다

var bbb = numbers2.map { number in
    return number * 1000// 각각의 아이템에 1000씩 곱해라는 방법을 제시한것
}

// [1000, 2000, 3000, 4000, 5000]
// 각각의 아이템을 꺼내서 1000을 곱해서 새로운 배열로 만들어서 리턴해라
print(bbb)


// 1)
var newNumbers = numbers.map { (num) in
    return "숫자: \(num)"
}

// 2) 파라미터 생략가능, 첫번째파라미터라는 의미로 $0써줘라
var newNumbers2 = numbers.map {
    return "숫자: \($0)"
}

// 3) 한줄이면 return도 생략가능
var newNumbers3 = numbers.map { "숫자: \($0)" }


print(newNumbers)
print(newNumbers2)
print(newNumbers3)





// String 배열
var alphabet = ["A", "B", "C", "D"]
var aaaa = alphabet.map { str in
    return str + "😎"     // ctrl + command + space
}

// ["A😎", "B😎", "C😎", "D😎"]
print(aaaa)


// 1)
var newAlphabet = alphabet.map { name in
    return name + "'s good"
}

// 2)
var newAlphabet2 = alphabet.map { (name) -> String in
    return name + "'s good"
}

// 3)


print(newAlphabet)
print(newAlphabet2)






// 배열리턴 예제


let transformedNumbers = numbers.map { num in
    return "Number: \(num)"
}

print(transformedNumbers) // 출력: ["Number: 1", "Number: 2", "Number: 3", "Number: 4", "Number: 5"]





// 함수 리턴 예제
// 함수를 리턴하는 고차함수는 함수 실행 결과로 또 다른 함수를 반환하는 것
// 이 함수는 increment라는 내부 함수를 반환하며, incrementer 변수에 저장된 함수는 5를 인자로 받아 6을 반환
func makeIncrementer() -> (Int) -> Int {
    func increment(number: Int) -> Int {
        return number + 1
    }
    return increment
}

let incrementer = makeIncrementer()
let result = incrementer(5) // result는 6이 됩니다.
