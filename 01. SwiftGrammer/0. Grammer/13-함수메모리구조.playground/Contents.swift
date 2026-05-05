/*
 
 
 함수
 - 반복되는 코드를 묵어서 쉽게 실행시킨다
 - 함수를 실행시키면 함수 이름을 찾아가서 코드를 실행시킨다
 

 
 플레이그라운드에 대한 가정(메모리 구조를 잘알기 위해)
 - 플레이그라운드는 main함수가 숨어있음
 - 플레이그라운드 전체 영역 = main함수의 영역이다
 
 
 (37강) 
 정리
 - 스택 프레임을 만드는 건 함수의 실행일 뿐이다
 - 조건문이나 반복문은 스택 프레임을 만드는 행위가 아니다
 - 함수 내에서 조건문은 스택 프레임 내에 뭔가를 만드는 것
 
 cpu에서 if문 살행방식
 
 
 */


func add(_ a: Int, _ b: Int) -> Int {
    var c = a + b
    return c
}

var num1 = 1
var num2 = 2
var num3 = add(num1, num2)

print(num3)


// 메모리 예제
var total: Int = 0  // 전역변수 = 데이터 영역에 저장됨

func square(_ i: Int) -> Int {
    return i * i
}

func squareOfSum(_ x: Int, _ y: Int) -> Int {
    var z = square(x + y)
    return z
}

func startFunction() {
    var a = 4
    var b = 8
    total = squareOfSum(a, b)
}

startFunction()





// 예제2: 전역변수로 가정
var a = 1
var b = 1

func addOneMore2() -> Int {
    b += 1
    return 5
}

func addOneMore1() {
    var num = 0
    a += 1
    num += addOneMore2()
    print(num)
}
addOneMore1()





// 예제3: 조건문(if문)의 명령어 구조
var c = 0

func someConditionalStatement(a: Int) {
    if a >= 0 {
        c += 1
    } else {
        c += 7
    }
}
someConditionalStatement(a: 0)




// 예제4: 반복문
// 전역변수
var d = 0
func someLoop() {
    for i in 1...5 {
        d += 1
    }
}
someLoop()











