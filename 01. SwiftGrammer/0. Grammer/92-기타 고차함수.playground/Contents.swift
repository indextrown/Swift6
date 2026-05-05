import UIKit

/*
 
 forEach함수
 - 각각의/각각을 위해서 라는 뜻
 - 기본 배열 등의 각 아이템을 활용해서 각 아이템별로 특정 작업(작업방식은 클로저가 제공)을 실행
 - (각 아이템을 활용해서 각각 특성 작업을 실행할때 사용)
 - 각각에 대해서 무엇을 한다
 
 - 이미 배열은 있고 배열에 있는 각각의 아이템을 꺼내서 클로저에 던져준다
 - 클로저는 리턴타입 없이 그냥 작업을 한다
 - 특정 작업을 실행하는게 forEach고차함수다
 
 compactMap
 - 자동으로 옵셔널 형식을 제거해준다
 - 옵셔널 바인딩까지 내장한다
 - 기존 배열 등의 각 아이템을 새롭게 매핑해서(매핑방식은 클로저가 제공)
 변형하되 옵셔녈 요소는 제거하고, 새로운 배열을 리턴(map + 옵셔널제거)
 
 
 
 flatMap
 - 내부의 중첩된 배열을 벗겨준다 평평하게 만들어준다
 
 */



// forEach 함수
let immutableArray = [1, 2, 3, 4, 5]
immutableArray.forEach { num in
    print(num)
}

immutableArray.forEach{ print("숫자: \($0)") }


// if let 바인딩 작업 불편하기때문에 옵셔널 요소를 제거하고, 새로운 배열을 리턴
let stringArray: [String?] = ["A", "B", "C", nil, "D"]
print(stringArray) // [Optional("A"), Optional("B"), Optional("C"), nil, Optional("D")]

var newStringArray = stringArray.compactMap { $0 }
print(newStringArray)   // nil은 제거하고 옵셔녈 스트링을 벗겨내서 새로운 배열을 리턴한다


let numbers = [-2, -1, 0, 1, 2]
// 0보다 크면 그대로 사용한다 그렇지 않으면 nil이 된다 --> 그런데 compactMap에서 nil을 제거하고 옵셔널 바인딩을 한다
var positiveNumbers = numbers.compactMap{ $0 >= 0 ? $0 : nil }
print(positiveNumbers)

// filter로 구현가능
//numbers.filter { $0 >=0 }


// filter + map을 통해서 compactMap 구현 가능
newStringArray = stringArray.filter { $0 != nil }.map { $0! }
print(newStringArray)
 

// flatMap
// 내부의 중첩된 배열을 벗겨서 하나의 배열에 담아서 리턴한다
var nestedArray = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
print(nestedArray.flatMap { $0 } )

var newNnestedArray = [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], [[10, 11], [12, 13, 14]]]
var numbersArray = newNnestedArray.flatMap { $0 }.flatMap { $0 }
print(numbersArray)
