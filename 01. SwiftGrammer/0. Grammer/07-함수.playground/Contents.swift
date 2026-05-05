/*
 
 (28강) 함수 기본 개념
 
 함수(중학 과정)
 - 기능을 하는 수학식
 
 함수(프로그래밍)
 - 기능을 하는 코드 모음
 - ()소괄호기호 = 함수를 실행하는 코드
 - 정의를 할 수 있고 실행 또는 사용할 수 있다
 - 함수는 1)정의문 2)실행문이 있다
 - 함수는 소문자로 이름 짓는다
 
 사용이유
 - 반복적 동작을 단순화
 
 표현식
 - 어떤 결과값으로 나올 수 있는것
 - 함수의 실행문도 표현식
 
 void
 - 리턴 타입이 없으면 void타입이다
 - 결과는 void 타입
 
 리턴 타입
 - 결과로 "값"이 있는 것
 
 
함수의 inp: 매개변수/인자: 함수 정의에 입력값으로 사용되는 변수(상수)
     oup: 인수/아규먼트: 함수 호출에 사용되는 실제 값/ 실행시 타입에 맞는 값전달
 
 
 
 
 
 
 (29강) 함수의 응용
 
 argument label(아규먼트 레이블)
 - first 다른 이름 가능
 - 함수가 무엇을 원하는 지 구체적 명시
 - 파라미터에 이름을 하나 더 붙힐 수 있음
 - 기존의 파라미터 이름 사용 불가??-> 겉에서 argument label명으로 보이고 내부에서 쓸때는 매개변수 이름으로 씀
 
 argument label 생략해서 사용 가능(와일드카트 패턴)
 - 언더바_(=와일드카드)사용
 - 생략하는 이유: 너무나도 명확한 경우 생략
 
 
 가변 파라미터
 - 함수에서 파라미터 개수가 정해지지 않은 가변 파라미터 개념을 사용할 수 있다
 - 하나의 파라미터로 두개 이상의 argument를 전달할 수 있다
 - 가변 파라미터는 개별 함수마다 하나씩만 선언 가능(선언 순서는 상관x )
 - 가변파라미터는 기본 값을 가질 수 없다
 - print도 가변 파라미터 사용
 
 print
 separator: “”
 terminator: “\n|

 
 */


// 전부 같은 코드
func say() {
    print("hello")
}

func say2() -> () {
    print("hello")
}

func say3() -> Void {
    print("hello")
}

// 아규먼트 레이블 여기서는 first
// name에 argument label을 설정
// 외부에서는 first로 보이고 내부에서는 name으로 보임
func arg(first name: String) {
    print("제 이름은 \(name) 입니다. ")
}
// arg(first: "김동현")


// argument label 생략!!
func addNum(_ firstNum: Int, _ secondNum: Int) {
    print(firstNum + secondNum)
}
addNum(1, 2)


// 가변 파라미터
// 함수에서 파라미터 개수가 정해지지 않은 가변 파라미터 개념을 사용할 수 있다
func myAverage(_ numbers: Double...) -> Double {
    var total = 0.0
    
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
print(myAverage(1, 2, 3, 4, 5))


// default값
func tell(_ say: String = "test") {
    print(say)
}
tell()          // test
tell("hello")   // hello

