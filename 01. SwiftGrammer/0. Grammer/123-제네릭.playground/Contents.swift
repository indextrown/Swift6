/*
 
 (183강)
 제네릭
 
 inout키워드(함수 마지막단원)
 - 파라미터는 기본적으로 let으로 선언되어 변형할 수 없다
 - 밖에 있는 변수의 주소를 그대로 가져오고 싶을 때 inout 파라미터를 사용한다
 - 그러면 함수 안에서 메모리 주소를 가지고 변수를 사용 가능해서 변수를 교환 가능하다

 MARK: 제네릭은 안쓰면 함수타입마다 모두 구현을 해야함(불편함)
 
 제네릭
 - 제네릭으로구현하면 함수를 하나만 구현해도 내부 타입을 언제든지 바꿔서 사용할 수 있다
 - 어떤 타입이 오더라도 내부적으로 교체해서 사용가능한 문법
 - 유연성이 늘어남
 
 타입파라미터
 - 함수 내부에서 파라미터 형식이나 리턴형으로 사용 가능
 
 */

// 제네릭이라는 문법의 필요성 알아보기

// 정수 2개
var num1 = 10
var num2 = 20


func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temp = a
    a = b
    b = temp
}

//print(num1, num2)
//swapTwoInts(&num1, &num2)
//print(num1, num2)

var num3 = 10.1
var num4 = 20.1
func swapTwoDouble(_ a: inout Double, _ b: inout Double) {
    let temp = a
    a = b
    b = temp
}

//print(num3, num4)
//swapTwoDouble(&num3, &num4)
//print(num3, num4)


// MARK: 타입만 바뀔 뿐인데 중복되는 코드를 구현해야되는게 개발자 입장으로 귀찮고 번거롭다
func PrintIntArray(array: [Int]) {
    for number in array {
        print(number)
    }
}

func PrintDoubleArray(array: [Double]) {
    for number in array {
        print(number)
    }
}

func PrintStringArray(array: [String]) {
    for number in array {
        print(number)
    }
}

func printArray<T>(_ array: [T]) {
    for number in array {
        print(number)
    }
}

var str = ["1", "2", "3", "4", "5"]


//printArray(str)

func swapTwoValue<T>(_ a: inout T, _ b: inout T) {
    let temp = a
    a = b
    b = temp
}

var str1 = "hello"
var str2 = "world"

print(str1, str2)
swapTwoValue(&str1, &str2)
print(str1, str2)

// 서로 다른 타입 교환
//func swapTwoValue<T, A>(_ a: inout T, _ b: inout A) {
//    let temp = a
//    a = b
//    b = temp
//}

// 리턴형을 정의하면 리턴타입도 정할 수 있음
//func swapTwoValue<T>(_ a: inout T, _ b: inout T) -> T {
//    let temp = a
//    a = b
//    b = temp
//    return a
//}



var test = [1, 2, 3].map { $0 * 10 }
print(test)
