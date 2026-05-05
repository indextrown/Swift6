import UIKit

/*
 메서드 요구사항
 - 클래스는 상속을 고려해야해서 생성자 앞에 required 붙여야함(하위에서 구현을 강제)
 
 
 required 생성규칙
 클래스
 - 다른 생성자를 구현하지 않으면 필수 생성자는 자동 상속된다
 - 만약 생성자를 직접 구현하면 필수 생성자 직접 구현해야함
 - final 키워드를 붙혀서 상속을 막을 수 있다
 - 클래스에서는 반드시 지정생성자로 구현할 필요없음(편의생성자로 구현해도 상관없다)
 
 구조체
 - 상속이 없기 때문에 required 필요 없다
 
 실패가능 생성자
 - 채택하는 곳에서는 실패가능하게 또는 실패불가능하게 구현해도됨
 - init?() 요구사항 - init() / init?() / init!()로 구현(0)
 - init()  요구사항 - init?()로 구현 (X - 범위가 더 넓어지는 것 안됨)
 
 */



protocol SomeProtocol {
    init(num: Int)
}

class SomeClass: SomeProtocol {
    
    required init(num: Int) {
        
    }
}

class SomeSubClass: SomeClass {
    // 다른 생성자를 구현하지 않으면 필수 생성자는 자동 상속된다
    // required init(num: Int) 자동 상속된상태
    
    // 만약 생성자를 직접 구현하면
    // 필수 생성자 직접 구현해야함
    init () {
        super.init(num: 12)
    }
    
    required init(num: Int) {
        fatalError("init(num: ) has not been implemented")
    }
}

// final로 상속을 막으면서 required를 생략 가능
final class Someclass3: SomeProtocol {
    init(num: Int) {
        
    }
}

struct SomeClass2: SomeProtocol {
    init(num: Int) {
        
    }
}

class Someclass4: SomeProtocol {
    required convenience init(num: Int) {
        self.init() // 편의생성자로 구현해서 자기 자신 생성자 호출
    }
    init() {
        
    }
}







protocol AProtocol {
    // 패택하는 곳에서 반드시 기본생성자 구현해야함
    init()
}

// 상위클래스
class ASuperClass {
    init() {
        
    }
}

// 상속 + 자격증 채택의 경우
class ASubclass: ASuperClass, AProtocol {
    // AProtocol을 채택함으로 "required"키워드 필요하고, 상속으로 인한 override(재정의) 키워드도 필요
    required override init() {
        
    }
}







// 실패가능 생성자
// 채택하는 곳에서는 실패가능하게 또는 실패불가능하게 구현해도됨
// init?() 요구사항 - init() / init?() / init!()로 구현(0)

// 실패 가능으로 정의한경우
protocol AProto {
    init?(num: Int)
}

struct Astruct: AProto {
    init?(num: Int) {}      // 실패가능 구현가능
//    init(num: Int) {}     // 실패불가능 구현가능
//    init!(num: Int) {}    // 강제로 벗기는 것도 가능
}

// 실패 불가능으로 정의한경우
protocol BProto {
    init?(num: Int)
}

struct Bstruct: BProto {
//    init?(num: Int) {}      // 실패가능 구현불가
    init(num: Int) {}     // 실패불가능 구현가능
//    init!(num: Int) {}    // 강제로 벗기는 것도 가능
}

