/*
 
 클래스 메모리 구조
 - 클래스는 데이터 영역에 붕어빵 틀이 있고
 - 붕어빵틀엣 붕어빵을 찍어내면 그 붕어빵(인스턴스)는 heap에 저장된다
 
 클로저의 메모리 구조
 - 클로저는 cpu에 대한 명령어의 묶음이라(즉 함수이다) 코드 영역에 들어있다
 - 코드영역의 주소를 저장해야하는데 heap 영역에 저장된다
 - 컴파일된 명령어의 메모리 주소가 heap에 저장된다
 - 클로저는 여러가지를 저장한다?(뒤에서)
 
 함수
 - 직접적인 실행은 스택 프레임에서 동작한다
 
 캡처현상
 - 클로저가 외부의 변수 stored를 사용하고 있기 때문에 외부의 변수를 계속적으로 사용해야되서 나한테(stored)에 저장한다
 
 정리
 - 함수를 변수에 저장하면 저장속성이 heap에 새롭게 저장된다

 
 */


// 클로저의 캡처현상
var stored = 0

let closure = { (num: Int) -> Int in
    stored += num
    return stored
}
closure(3)
closure(4)

// 일반적인 동작
var test = 0
func add(_ num: Int) -> Int {
    test += num
    return num
}
add(3)
add(4)




// 캡처 현상 없는 일반 예제
// 값을 리턴
func calculate(number: Int) -> Int {
    var sum = 0
    
    func square(num: Int) -> Int {
        sum += (num * num)
        return sum
    }
    
    let result = square(num: number)
    return result
}
calculate(number: 10)
calculate(number: 20)
calculate(number: 30)


// 변수를 캡처하는 함수
// 함수를 리턴
func calculate2() -> (Int) -> Int {
    var sum = 0
    
    func square(num: Int) -> Int {
        sum += (num * num)
        return sum
    }
    
    return square // 함수를 실행하는게 아니라 가리킨다
}
 
// square 함수를 리턴한다
// squareFunc 변수에 square함수가 할당된다
var squareFunc = calculate2()
squareFunc(10)
squareFunc(20)
squareFunc(30)
// 캡처하는 현상이 발생한다
// 값을 지속적으로 저장하고있는 일이 일어난다는것


// 변수에 할당하지 않고 실행한다면?
// 캡처현상 발생안함(스택프레임만 사용한다)
calculate2()(10)
calculate2()(20)
calculate2()(30)

