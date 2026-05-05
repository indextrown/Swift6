/*
 
 (107강)
 
 초기화
 - 클래스나 구조체 또는 열거형에서 인스턴스를 생성하는 과정
 - 각 저장속성에 대한 초기값을 설정해서 메모리 공간에 값을 찍어서 인스턴스를 사용가능한 상태로 만드는 것
 
 이니셜라이즈 완료되면
- 인스턴스의 모든 저장속성이 초기값을 가지는 것 ==> 생성자 역할
 
 초기화의 방법(저장속성의 초기값 가져야함)
 - 1) 저장속성의 선언과 동시에 값을 저장
 - 2) 저장속성을 옵셔널로 선언(초기값 없어도 nil로 초기화됨) -> 생성자 필요x
 - 3) 생성자에서 값을 초기화
 - 반드시 생성자를 정의해야만 하는 것은 아님
 - 컴파일러는 기본 생성자를 자동으로 생성자 ==>init()
 - 이니셜라이저 구현하면 기본 생성자를 자동으로 생성하지 않음
 
 멤버와이즈 이니셜라이저
 - 구조체의 특별한 생성자
 - 멤버에 관하여~: 모든 멤버와 관련된 생성자를 멤버와이즈 이니셜라이저라한다
 
 생성자의 기본 원칙
 - 개발자가 따로 구현안하면 컴파일러가 기본 생성자 구현함
 - 이니셜라이저 구현하면 기본 생성자 구현안됨
 
 구조체는 저장 속성이. "기본값을 가지고 있더라도" 추가적으로 멤버와이즈이니셜라이저제공(기본생성자 + 멤버와이즈이니셜라이저제공)
 
 왜 구조체만 멤버와이즈이니셜라이저제공?
 - 구조체는 클래스보다 자주 사용한다
 - 개발자가 자주, 편하게 쓰기위해 제공 추측
 - 클래스의 경우 생성자가 상속과 관련 있기 때문에 복잡함
 
 개발자가 직접 이니셜라이즈(생성자)구현하면 멤버와이즈이니셜라이저 자동제공x 

 */


class Color {
    let red: Double
    let green: Double
    let blue: Double
    
    // 생성자도 오버로딩을 지원한다(파라미터수, 아규면트레이블, 자료형으로 구분)
    // 기본생성자 -> 저장 속성의 기본값을 설정하면 "자동" 구현이 제공됨 !!!!!!!!!!!!!!!!!
    init() {
        red = 0.0
        green = 0.0
        blue = 0.0
    }
    
    init(white: Double) {
        red = white
        green = white
        blue = white
    }
    
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}

var color1 = Color()
var color2 = Color(white: 10.0)
var color3 = Color(red: 1.1, green: 2.2, blue: 3.3)



// 멤버와이즈 이니셜라이저
struct Color1 {
    // 저장속성도 초기화되지 않고 생성자 없어도 오류 안남
    var red: Double
    var green: Double
    var blue: Double
    
    // 컴파일러가 알아서 넣어줌
//    init(red: Double, green: Double, blue: Double) {
//        self.red = red
//        self.green = green
//        self.blue = blue
//    }
}
 
// var c2 = Color1(red: <#T##Double#>, green: <#T##Double#>, blue: <#T##Double#>)

