/*
 (87강)
 - self는 인스턴스 즉 실제 데이터를 의미한다
 
 초기화 메서드/이니셜라이저
 - init(파라미터)
 - 모든 저장 속성(변수)를 초기화 해야함(구조체, 클래스 동일) = 모든 변수에 값을 넣어줘야한다
 - 생성자의 실행 종료시점에 모든 속성의 초기값이 저장되어 있어야 함(초기화가 완료되지 않으면 컴파일 에러)
 - 생성자의 목적은 결국 저장속성 초기화
 - 저장속성 = 변수
 - 클래스, 구저체, (열거형)은 모두 설계도일뿐
 - 실제 데이터(속성), 동작(메서드)를 사용하기 위해 초기화 과정이 반드시 필요
 
 생성자
 - 데이터를 실제로 메모리에 생성하기위한 필수적인 과정
 */

class Dog {
    var name: String
    var weight: Double
    
    // 생성자(initializer) = 초기화 메서드
    init() {
        self.name = ""
        self.weight = 0.0
    }
    
    init(name n: String, weight w: Double) {
        self.name = n   // 왼쪽 인스턴스의 name 오른쪽: 파라미터의 name
        self.weight = w
    }
    
    func sit() {
        print("앉았습니다")
    }
}

var test = Dog()
test.name
test.weight

var bori = Dog(name: "보리", weight: 1.5)
bori.name
bori.weight

var choco = Dog(name: "초코", weight: 7.0)
choco.name
choco.weight

// 정식문법
var happy = Dog.init(name: "해피", weight: 1.0)

