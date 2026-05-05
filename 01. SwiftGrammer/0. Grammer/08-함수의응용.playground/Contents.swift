// 아규면트 레이블: first 다른 이름 가능
// 함수가 무엇을 원하는 지 구체적 명시
func printtName(first name: String) {
    print("나의 이름은 \(name) 입니다. ")
}

printtName(first: "김동현")

func someFunction(writeYourFirstNumber a: Int, writeYourSecondNumber b: Int) {
    print(a+b)
}
//someFunction(writeYourFirstNumber: 10, writeYourSecondNumber: 20)


// 아규먼트 레이블을 생략해서 사용가능(와일드카드 패턴)
// 사용 이유: 매개변수가 명확할 때
func addPrintNum(_ firstNum: Int, _ secondNum: Int) {
    print(firstNum + secondNum)
}
//addPrintNum(1, 2)


// 가변 파라미터- 함수의 파라미터에 정해지지 않은, 여러개의 값을 넣기
// 여러개의 데이터가 전달된다
// 가변파라미터는 기본 값을 가질 수 없다
func arithmeticAverage(_ numbers: Double...) -> Double {
    var total = 0.0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
// arithmeticAverage(1.5, 2.5)


// 파라미터에 기본값(디폴트) 정하기
func myadd(num1: Int, num2: Int = 5) -> Int {
    return num1 + num2
}

myadd(num1: 2, num2: 3)
myadd(num1: 2)
