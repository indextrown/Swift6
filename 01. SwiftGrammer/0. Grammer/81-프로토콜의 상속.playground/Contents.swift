import UIKit

/*
 
 (131강)
 프로톸의 상속이 가능하다
 프로토콜은 다중상속이 가능하다
 어차피 여러가지 요구사항의 나열일뿐이다
 개발자가 프로토콜을 상속하는 경우 잘 안씀
 프로토콜을 &로 연결해서, 프로토콜 두개를 병합해서 타입으로 사용하는 것 가능
 
 
 */

protocol Remote {
    // 요구사항 1
    func turnOn()
    // 요구사항 2
    func turnOff()
}

protocol AirConRemote {
    func Up()
    func Down()
}

protocol SuperRemotsProtocol: Remote, AirConRemote {
    // func turnOn()
    // func turnOff()
    // func Up()
    // func Down()
    func doSomething()
}

// 프로토콜의 채택 및 구현
class HomePot: SuperRemotsProtocol {
    // 요구사항 구현
    func turnOn() {}
    func turnOff() {}
    func Up() {}
    func Down() {}
    func doSomething() {}
}

// 프로토콜을 클래스 전용 프로토콜로 구현 가능하다
// AnyObject는 프로토콜이다
// AnyObject는 이전에 클래스의 인스턴스를 담을 수 있는 타입이라고 했음
// AnyObject프로토콜을 상속해서 클래스를 만들면 이는 클래스 전용 프로토콜이된다
// 구조체에서는 채택할 수 없게 됨
// AnyObject는 프로토콜이라서 범용적 타입으로 사용할 수 있었던 것이고, 다운캐스팅(as? as!해서 구체적인 실제타입으로 사용 가능하다)
protocol SomeProtocol: AnyObject {
    // func doSomething()
}

class AClass: SomeProtocol {
    func doSomething() {
        print("Do something")
    }
}

// 프로토콜의 합성
protocol Named {
    var name: String { get }
}

protocol Aged {
    var age: Int { get }
}

struct Person: Named, Aged {
    var name: String
    var age: Int
}

//func wishHappyBirthday(to celebrator: Person)
//func wishHappyBirthday(to celebrator: Named)

// 프로토콜의 합성
// Named, Aged 두가지 프로토콜을 다 채택한 타입을 의미한다
// Named & Aged: 두가지 프로토콜을 다 채택한 타입을 의미한다
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("생일축하해, \(celebrator.name), 넌 이제 \(celebrator.age)살이 되었구나!")
}

let birthdayPerson = Person(name: "홍길동", age: 20)
wishHappyBirthday(to: birthdayPerson)
// 임시적인 타입으로 저장(두개의 푸로토콜을 모두 채택한 타입만 저장 가능)
let whoIsThis: Named & Aged = birthdayPerson    // == 인스턴스


(whoIsThis as? Person)?.name
(whoIsThis as! Person).name

