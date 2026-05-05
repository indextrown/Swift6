// 함수정의
// 함수는 소문자로 짓는다
// 함수는 기능을 하는 코드 모음
// 정의를 할수 있고 실행 또는 사용할 수 있다
func doSomething() {
    for i in 1...3 {
        print(i)
    }
}
// 함수의 실행문
//doSomething()

// 함수의 input: 파라미터 = name
func saySomethihg(name: String) {
    print("안녕하세요 \(name) 입니다. ")
}
//saySomethihg(name: "Index")

// 함수의 소괄호에 들어가는 것: 파라미터 a: Int
// a: 파라미터 이름
// Int: 파라미터 타입
func doSomething2(a: Int) {
    for _ in 1...5 {
        print(a)
    }
}

// 실질적 숫자 7: argument
// doSomething2(a: 7)
var num = 8 // 타입 추론
//doSomething2(a: num)

// output이 있는 경우
func sayHello() -> String {
    return "안녕하세요"
}
var name: String = sayHello()
//print(name)

// 함수의 input, output 모두 있는 경우1
// 함수의 input 여러개 가능 output 1개 가능
func sayHello2(name: String) -> String {
    return name
}
var name2 = sayHello2(name: "Index")
//print(name2)

// 함수의 input, output 모두 있는 경우2
func plusFunction(a: Int, b: Int) -> Int {
    return a + b
}

//print(plusFunction(a: 1, b: 2))
//print(plusFunction(a: 5, b: 6))

// 함수 정의문
func someFunction(x: Int) -> Int {
    var y = 2 * x + 3
    return y
}

// 함수 실행문
//print(someFunction(x: 5))



// 활용
func say(a: String) -> String {
    var say: String = "안녕 반가워. \(a) 나는 스위프트라고 해"
    return say
}
//print(say(a: "김동현"))

// void 타입 3가지 방법 모두 동일
// void = 비어있다 = 리턴형이 없다
func test() {
    print("hello swift")
}

func test2() -> () {
    print("hello swift")
}

func test3() -> void {
    print("hello swift")
}

// 거의 사용 안함
var hello: Void = test3()
