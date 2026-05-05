/*
 
 (108강)

 생성자
 - 구조체 vs 클래스 생성자
 
 
 클래스 생성자
 - 다른생성자를 호출할 경우 convenience 붙여야함
 - 구조체는 convenience 안붙히는데 클래스는 convenience 붙이는 이유는 하위 클래스에서 재정의할 필요가 없다 그런 의미
 // 지정생성자(designated: 데지크네이티드 = 어떤 것을 지정한다): 일반적인 이니셜라이저
 // 편의생성자: 편리한 생성자(다른 생성자를 호출하는 녀석)
 
 편의생성자
 - 개발자가 붕어빵찍어낼때 훨씬 더 편리하게 찍어낼 수 있도록 만들어진 기능
 - 편리하게 생성하기 위한 서브생성자
 - 지정상성자는 모든 속성 초기화 필요 편의생성자는 모든 속성 초기화 할 필요 없음
 - 상속관계에서 개발자가 실수 할 수 있는 여러가능성을 배제하기 위한 생성자이다
 - 모든 속성을 초기화하지않으면 ===>편의생성자로 만드는 것이 복잡도나 실수 줄일 수 있음
 
 */

// 구조체 생성자
struct Color {
    let red, green, blue: Double // 기본값 설정 안된상태
    
    init() {    // 기본생성자: 기본값 설정하면 자동으로 제공됨
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


// 추천하는 방식(실수 확률 줄어듬)
// 중복하지 않고 하나의 정식적인 생성자를 만들고 다른 생성자에서 호출하는 방식
struct Color1 {
    let red, green, blue: Double // 기본값 설정 안된상태
    
    init() {
        self.init(red: 0.0, green: 0.0, blue: 0.0)
    }
    
    init(white: Double) {
        self.init(red: white, green: white, blue: white)
    }
    
    // 정식적인 생성자
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}




// 클래스 생성자
// 지정생성자(designated: 데지크네이티드 = 어떤 것을 지정한다): 일반적인 이니셜라이저
// 편의생성자: 편리한 생성자(다른 생성자를 호출하는 녀석)
class Color2 {
    let red, green, blue: Double // 기본값 설정 안된상태
    
    // 편의기본생성자
    convenience init() {
        self.init(red: 0.0, green: 0.0, blue: 0.0)
    }
    
    // 편의생성자
    convenience init(white: Double) {
        self.init(red: white, green: white, blue: white)
    }
    
    // 정식적인 생성자 = 지정생성자
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}



// 편의생성자: 개발자가 붕어빵찍어낼때 훨씬 더 편리하게 찍어낼 수 있도록 만들어진 기능
class Dog {
    var name: String
    var weight: Double
    
    
    // 지정생성자
    // 지정생성자 안에는 기본생성자도 있음
    init(name: String, weight: Double) {
        self.name = name
        self.weight = weight
    }
    
    // 편의생성자
    convenience init(name: String) {
        self.init(name: name, weight: 10.0)
    }
    
    // 편의기본생성자
    convenience init() {
        self.init(name: "강아지", weight: 10.0)
    }
}

var dog1 = Dog(name: "강아지", weight: 10)
var dog2 = Dog(name: "보리")
dog2.weight

var dog4 = Dog()
dog4.name
dog4.weight





// 클래스의 상속과 지정/편의 생성자 사용예시

class Aclass {
    // 저장속성
    var x: Int
    var y: Int
    
    // 지정생성자: 모든 저장속성을 설정
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    // 편의생성자: 모든 저장속성을 설정하지 않음
    convenience init() {
        self.init(x: 0, y: 0)
    }
}

class Bclass: Aclass {
    // 저장속성
    var z: Int
    
    // 지정생성자 새로 정의
    // 지정생성자는 반드시 재정의해야함
    init(x: Int, y: Int, z: Int) {
        self.z = z             // (필수)
        // self.y = y          // 불가능 -> 메모리에 찍어내지 않음 -> 찍어내는건 지정생성자에서 진행한다
        super.init(x: x, y: y) // (필수) 상위의 지정생성자 호출
        self.y = 7             // 가능
        self.doSomething()     // 잘안쓰지만 가능
    }
    
    // 편의생성자 다시 정의. ---> 지정생성자를 호출하도록 만듬
    // 편의생성자는 상속이 되지 않는다->
    // 상속이 되었으면 override붙여야했음
    // 재정의됨
    convenience init(z: Int) {
        self.init(x: 0, y: 0, z: 0)
    }
    
    // 재정의됨
    convenience init() {
        self.init(z: 0)
    }
    
    func doSomething() {
        print("Do something")
    }
}


