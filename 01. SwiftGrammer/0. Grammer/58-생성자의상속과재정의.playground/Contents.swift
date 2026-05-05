/*
 
 (110강)
 생성자의 상속/재정의
 메서드는 재정의 가능
 저장속성은 재정의 불가 이유: 데이터를 추가하는 작업이기 때문
 
 생성자
 - 모든 저장속성을 초기화하는 도구
 - 메서드이긴 메서드이나 특이한 규칙 존재한다
 - 상위클래스에서 만든 생성자는 하위 클래스에서 최적화 되어 있지 않음
 
 하위클래스는 기본적으로 상위클래스 생성자를 상속하지 않고 재정의 하는 것이 원칙
 -> 이유: 하위클래스에 최적화 안되어 있음
 -> 예외적으로 (안전한 경우)에만 상위클래스의 생성자가 자동 상속됨
 
 
 
 
 
 원칙: 1) 상위 지정생성자(이름/파라미터)오 2)현재단계의 저장속성을 고려해서 구현해야한다
 
 (1단계 - 상위 생성자에 대한 고려)
 (상위) 지정생성자 ==>   1) 하위클래스에서 지정생성자로 구현(재정의)
                     2) 하위클래스에서 편의 생성자로 구현(재정의)
                     3) 구현 안해도됨(반드시 재정의하지 않아도 됨)
 
 (상위) 편의생성자 ==>    재정의를 하지 않아도 됨(호출 불가가 원칙이기 때문에 재정의 제공 안함)
               ==>    만약 하위에 동일한 이름을 구현했다면 그냥 새롭게 정의한것임

 
 (2단계 - (현재단계의) 생성자 구현)
 
 1) 지정생성자 내에서
 ===> (1) 나의 모든저장속성을 초기화해야함
 ===> (2) 슈퍼 클래스의 지정생성자 호출해야함
 
 2) 편의생성자 내에서
 ===> 현재 클래스의 지정생성자 호출해야함(편의생성자를 거치는 것은 상관없음
      (결국 지정 생성자만 모든 저장 속성을 초기화 가능
 
 
 // 정리 편의생성자로 구현하지 않으면 super.init()호출해야함
 */


// 기본(Base)클래스
class Aclass {
    // x저장속성에 기본값 부여
    var x = 0
    
    // init() {} // 기본생성자 구현안하면 컴파일러가 알아서 넣어줌
}

// 상위의 지정생성자 = init() = 기본생성자
// ctrl + command + space
class Bclass: Aclass {
    var y: Int
    
    // (선택1) 지정생성자로 재정의
    override init() {
        self.y = 0
        
        // 하위 지정생성자는 반드시 상위 지정생성자 호출해야한다 = delegate up 해야한다
        super.init()
    }
    
    // (선택2) 편의생성자로 재정의. 편의생성자는 나의 단계에서 지정생성자를 호출해야함
    // 편의생성자는 나의 단계에 있는 지정생성자를 호출해야함 => 현재단계의 지정생성자 만들어줘야함
//    override convenience init() {
//        self.init(y: 0)
//    }
        
    // (선택3) 재정의 하지 않을 수도 있음(상속 안함). (재정의안하고 새로 구현한거임) override 안적혀있음
    // 이유: 현재 단계의 생성자를 잘 구현해놓아서
    // 지정 생성자
    // 매개변수 달라서 재정의(overriding) 필요 x
    init(y: Int) {
        self.y = y
        super.init()
    }
}




// 상위의 지정생성자 고려해야함
// init()
// init(y: Int)

// 고려사항
// 재정의를 할지, 편의생성자로 재정의를 할지, 상속을 안할지 선택해야함
class Cclass: Bclass {
    var z: Int
    
    // 상위 클래스와 "이름이 동일한 생성자" 구현(올바른 재정의)
    override init() {
        self.z = 0
        super.init()    // 기본 생성자만 있는 경우 생략가능
    }
    
    // 지정생성자(convenience안씀)
    // 상위의 지정생성자를 호출만 하면 됨
    override init(y: Int) {
        self.z = 0
        super.init(y: y)
    }
    
    init (z: Int) {
        self.z = z
        super.init()
    }
}
  


class Vehicle {
    // 저장속성
    var numberOfWheels = 0
    
    // 계산속성
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
    
    // init() {}
}


let vehicle = Vehicle()
print(vehicle.description)



class Bicycle : Vehicle {
    // 상위 지정생성자 고려
    // 재정의
    override init() {
        super.init()        // 슈퍼클래스 호출 반드시 필요
        numberOfWheels = 2  // 초기화의 2단계 값설정
    }
}

class Hoverboard: Vehicle {
    // 저장속성
    var color: String
    
    // override 할수도 있는데 할지 안할지 고민해봐야함 -> 원칙만 지켜야함
    // 원칙: 나의 단계의 저장속성을 설정 해주는 것
    
    // 1. 상위 지정생성자 고려(상위 지정생성자 원칙을 다 지킨 구현)
//    override init() {
//        self.color = "빨간색"
//        super.init()
//    }
    
    
    // 2. 편의생성자로 구현가능(나의 단계에 있는 지정생성자 호출해야함)
//    override convenience init() {
//        self.init(color: "빨간색")
//    }
    
    // 지정생성자
    init(color: String) {
        self.color = color
        // super.init()
        // 상위의 지정생성자에서 기본생성자만 존재하면 기본생성자 호출 생략가능-> 암시적으로 호출 되기 때문이다
    }
    
}
