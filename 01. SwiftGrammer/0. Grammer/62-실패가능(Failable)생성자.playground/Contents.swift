/*
 
 
 (113강)
 실패가능생성자
 - 인스턴스 생성에 실패할 수도 있는 가능성을 가진 생성자(클래스, 구조체, 열거형 가능)
 - 실패가 불가능하게 만들어서 에러가 나고 앱이 완전히 꺼지는 가능성보다는
 실패가능 가능성 생성자를 정의하고 그에 맞는 예외 처리를 하는 것이 더 올바른 방법이다
 
 - 생성자에 ?를 붙여서 init?(파라미터)라고 정의하면 됨
 - 다만 동일한 파라미터를 가진 생성자는 유일해야함-> 오버로딩으로 실패가능/불가능을 구분 불가능함
 
 [포함관계]
 델리게이트 어크로스
 실패가능생성자는 실패불가능생성자를 호출 가능
 실패불가능생성자는 실패가능생성자를 호출 불가능
 
 [상속관계에서도 적용됨]
 - 히위에서 동일한 이름으로 지정생성자가 있는데 이는 상위의 지정생성자를 호출해야한다 == 델리게이트 업
 - 실패불가능 생성자에서 실패가능 생성자 호출 할 수 없다---> 포함관계 그림 파악
 - 하위 실패가능 생성자에서 상위 실패불가능 생성자 호출 가능
 */


class Animal {
    let species: String
    
    // 실패가능 생성자
    // 인스턴스 찍어내기 실패시 nil을 반환
    init?(species: String) {
        if species.isEmpty {    // 문자열이 비어있는 경우
        // if species == ""
            return nil
        }
        self.species = species
    }
    
    // 오버로딩 구분 불가로 동일한 이름 구현 불가능
    // init(species: String) {}
}

// 엄일히 말하면 생성자는 값을 반환하지 않고, 초기화가 끝날 때까지 모든 저장 속성이 값을 가져 올바르게 초기화하도록 하는 것임
// 초기화 성공을 나타내기 위해 return 키워드를 사용하지 않음 ( 문법적 약속 )
let a = Animal(species: "Giraffe")
let b = Animal(species: "")
//print(a)
//print(b) // nil



enum TemperatureUnit {
    case kelvin
    case calsius
    case fahrenheit
    
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = TemperatureUnit.kelvin
        case "C":
            self = TemperatureUnit.calsius
        case "F":
            self = TemperatureUnit.fahrenheit
        default:
            return nil
        }
    }
}


// 열거형 인스턴스 생성
// 1) 생성자로 생
// 2) 이름.case로 가능 이때는 Optional 타입이 아니다 이름타입이다
// 열거형이라서 값을 하나 찍어내야함
let c: TemperatureUnit = TemperatureUnit.calsius        // TemperatureUnit 타입 = TemperatureUnit()라고 생각하자
let F: TemperatureUnit? = TemperatureUnit(symbol: "F")  // Optional 타입

// 원시값 활용
enum TemperatureUnit1: Character {
    case kelvin = "K"
    case calsius = "C"
    case fahrenheit = "F"
}

let f1: TemperatureUnit1? = TemperatureUnit1(rawValue: "F") // .fahrenheit
let u: TemperatureUnit1? = TemperatureUnit1(rawValue: "X")




// 실패가능생성자는 실패불가능생성자를 호출 가능
struct Item {
    var name = ""
    
    // 실패불가능생성자
    init() {
        
    }
    
    // 실패가능생성자
    init?(name: String) {
        self.init()
    }
}


// 실패불가능생성자는 실패가능생성자를 호출 불가능
//struct Item2 {
//    var name = ""

    // 실패불가능생성자
//    init() {
//        self.init(name: "hello")
//    }
//    
    // 실패가능생성자
//    self?(name: String) {
//        self.name = name
//    }
//}








// 상속
class Product {
    let name: String
    
    // 실패가능생성자
    init?(name: String) {
        if name.isEmpty {return nil}
        self.name = name
    }
}

// 상위에 있는 지정생성자 재정의 안했음
class CartItem: Product {
    let quantity: Int
    
    // 실패가능생성자
    init?(name: String, quantity: Int) {
        if quantity < 1 {return nil}
        self.quantity = quantity
        super.init(name: name)
    }
}

