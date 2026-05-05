import UIKit

//let numbers = [1, 2, 3, 4, 5]
//
//var myMap = numbers.map { num in
//    return "숫자: \(num)"
//}
//
//print(myMap) // ["숫자: 1", "숫자: 2", "숫자: 3", "숫자: 4", "숫자: 5"]


//let numbers = [1, 2, 3, 4, 5]
//
//// 1) 반환 타입을 String으로 지정
//var newNumbers = numbers.map { (num) -> String in
//        return "숫자: \(num)"
//}
//
//// 2) Swift가 타입을 추론하도록 하는 방법
//var newNumbers2 = numbers.map { num in
//        return "숫자: \(num)"
//}
//
//// 3) 파라미터 생략가능
//var newNumbers3 = numbers.map {
//        return "숫자: \($0)"
//}
//
//// 4) 클로저가 한 줄로 작성될 경우 return 키워드를 생략가능
//var newNumbers4 = numbers.map { "숫자: \($0)" }
//
//print(newNumbers)
//print(newNumbers2)
//print(newNumbers3)
//print(newNumbers4)
//
//var alphabet = ["A", "B", "C", "D"]
//var result = alphabet.map { str in
//      return str + "😎"  // ctrl + command + space
//}
//print(result)
//
//
//
//let rawData = [10, 15, 20, 25, 30]
//let processedData = rawData.filter { $0 <= 15 }.map { "\($0) <= 15" }
//print(processedData)


//"Swift".contains("S")
//
//
//let names = ["Apple", "Black", "Circle", "Dream", "Blue"]
//
//// filter: 문자열을 input으로 가지고 output으로 Bool 타입을 가지는 클로저를 가지는 고차함수
//var result = names.filter { str in
//        return str.contains("B")
//}


// 짝수만만 모아서 리턴
//let array = [1, 2, 3, 4, 5, 6, 7 ,8]
//
//// 1) 반환 타입을 Bool로 지정
//var evenNumberArray = array.filter { (num) -> Bool in
//        return num % 2 == 0
//}
//
//// 2) Swift가 타입을 추론하도록 하는 방법
//var evenNumberArray2 = array.filter { num in
//        return num % 2 == 0
//}
//
//// 3) 파라미터 생략가능
//var evenNumberArray3 = array.filter {
//        return $0 % 2 == 0
//}
//
//// 4) 클로저가 한 줄로 작성될 경우 return 키워드를 생략가능
//var evenNumberArray4 = array.filter { $0 % 2 == 0 }
//
//
//print(evenNumberArray)
//print(evenNumberArray2)
//print(evenNumberArray3)
//print(evenNumberArray4)


//
//var array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
//
//var result = array.reduce(100) { (accumulator, element) in
//    return accumulator - element
//}
//
//var result2 = array.reduce(100) { $0 - $1 }


//var array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
//
//var myString = array.reduce("0") { result, item in
//    return result + String(item)
//}
//
//var result = array.filter { $0 % 2 != 0 }.map { $0 * $0 }.reduce(0) { $0 + $1 }


//let immutableArray = [1, 2, 3, 4, 5]
//
//immutableArray.forEach { num in
//        print(num)
//}
//// 1
//// 2
//// 3
//// 4
//// 5
//
//immutableArray.forEach { print("숫자: \($0)") }
////숫자: 1
////숫자: 2
////숫자: 3
////숫자: 4
////숫자: 5
//
//
//let stringArray: [String?] = ["A", "B", "C", nil, "D"]
//print(stringArray)
//// [Optional("A"), Optional("B"), Optional("C"), nil, Optional("D")]
//
//var newStringArray = stringArray.compactMap { $0 }
//print(newStringArray)
//
//
//let numbers = [-2, -1, 0, 1, 2]
//
//var positiveNumbers = numbers.compactMap { $0 >= 0 ? $0 : nil }
//print(positiveNumbers)


class Dog {
    var name: String?   // 옵셔널스트링: 초기값 없으면 nil로 세팅된다
    var weight: Int
    
    init(name: String, weight: Int) {
        self.name = name
        self.weight = weight
    }
    
    func sit() {
        print("\(self.name)가 앉았습니다.")
    }
    
    func sit2() {
            if let name = self.name {
                         print("\(name)가 앉았습니다.")
            }
    }
    
    func layDown() {
        print("누웠습니다.")
    }
}

//var choco = Dog(name: "초코", weight: 15)
//print(choco.name) // name타입: 옵셔널 스트링
//choco.sit()
//choco.sit2()

var choco: Dog? = Dog(name: "초코", weight: 15)
print(choco?.name)
choco?.sit()

class Human {
    var dog: Dog?
}

var human = Human()

human.dog = choco
// human의 dog속성이 옵셔널 타입이기 때문에 ? 필요하다
// 마지막 속성 name은 옵셔널이라도 ? 필요가 없다
human.dog?.name



var human2: Human? = Human()
human2?.dog = choco
print(human2?.dog?.name)

//class Test {
//    var temp: Int?
//}
//
//var t = Test()
//print(t.temp)
//
//var tt = Test()
//tt.temp = 1
//print(tt.temp)
//
// 1) 앞의 옵셔널타입에 값이 있다는 것이 확실한 경우
print(human2!.dog!.name)      // Optional("초코")
print(human2!.dog!.name!)     // 초코

// 2) if let 바인딩
if let name = human2?.dog?.name {
        print(name)
}

// 3) Nil-Coalescing 연산자
var name = human2?.dog?.name ?? "청개구리"
print(name)
