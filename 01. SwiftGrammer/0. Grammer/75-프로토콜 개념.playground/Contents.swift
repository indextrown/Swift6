import UIKit

/*
 
 프로토콜 = 규약 / 협약
 프로토콜 = 채택을 하고 사용하는것
 프로토콜은 구조체에서도 채택, 하위클래스에서도 채택 가능한다
 - 자격증, 운전면허증으로 생각-> 운전면허증을 따면 운전 가능하다
 - 간단한 규칙만 따르면 능력을 갖게 된다
 
 클래스
 - 상속가능(클래스에서만)
 - 상속단점: 다중상속불가(하나의 클래스만 상속 가능)
 - 상위 클래스의 메모리구조를 따라간다 즉 저장속성의 메모리구조는 따라갈 수 밖에 없는 구조다
 - 필요하지 않은 속성이나 메서드도 따라갈 수 밖에 없다(필요없어도 물려받는다)
 - 이러한 단점 때문에 프로토콜이라는게 도입되고 사용되었다
 
 */


// 프로토콜: 영어로 규약/협약/액속/자격증/리모콘
// 클래스와 상속의 단점
class Bird {
    var isFemale = true
    
    func layEgg() {
        if isFemale {
            print("새가 알을 낳는다.")
        }
    }
    
    func fly() {
        print("새가 하늘로 날아간다.")
    }
}

class Eagle: Bird {
    // 저장속성과 메서드 자동상속
    // isFemale
    // layEgg()
    // fly()
    
    func soar() {
        print("공중으로 치솟아 난다.")
    }
}

class Penguin: Bird {
    // isFemale
    // layEgg()
    // fly()
    
    // fly()          // 상속 구조에서는 펭귄이 어쩔 수 없이 날게됨
    
    func swim() {
        print("헤엄친다.")
    }
}

class Airplane: Bird {
    // isFemale
    // layEgg()       // 상속 구조에서는 비행기가 알을 낳게됨
    override func fly() {
        print("비행기가 엔진을 사용해서 날아간다")
    }
}

struct FlyingMuseum {
    func flyingDemo(flyingObject: Bird) {
        flyingObject.fly()
    }
}

let myEagle = Eagle()
myEagle.fly()
myEagle.layEgg()
myEagle.soar()

let myPenguin = Penguin()
myPenguin.layEgg()
myPenguin.swim()
myPenguin.fly()         // 문제 ==> 펭귄이 날게 됨

let myPlane = Airplane()
myPlane.fly()
myPlane.layEgg()        // 문제 ==> 비행기가 알을 낳음

let museum = FlyingMuseum()
museum.flyingDemo(flyingObject: myEagle)
museum.flyingDemo(flyingObject: myPenguin)
museum.flyingDemo(flyingObject: myPlane)

/*
 프로토콜
 fly()라는 동작을 따로 분리해서 굳이 상속을 하지 않아도 사용가능하게 하려면?
 꼭 클래스가 아닌 구조체에서도 fly()기능 동착하게 하려면?
 */

// 프로토콜 작성법
// 1) 프로토콜을 정의한다
// 2) 메서드 헤드부분만 작성한다
protocol CanFly {
    func fly()  // 구체적인 구현은 하지 않음 ==> 구체적인 구현은 자격증을 채택한 곳에서
}


class Bird1 {
    var isFemale =  true
    
    func layEgg() {
        if isFemale {
            print("새가 알을 낳는다.")
        }
    }
}

class Eagle1: Bird1, CanFly {
    // isFemale
    // layEgg()
    
    func fly() {
        print("독수리가 하늘로 날아올라 간다.")
    }
    
    func soar() {
        print("공중으로 활공한다")
    }
}

class Penguin1: Bird1 {
    // isFemale
    // layEgg()
    
    func swim() {
        print("물 속을 헤엄칠 수 있다.")
    }
}

struct Airplane1: CanFly {
    func fly() {
        print("비행기가 날아간다")
    }
}

struct FlyingMuseum1 {
    // 중요기능=> 프로토콜을 타입으로 원칙
    // CanFly자격증을 딴 클래스, 구조체 모두 가능
    func flyingDemo(flyingObject: CanFly) {
        flyingObject.fly()
    }
}


let myEagle1 = Eagle1()
myEagle1.fly()
myEagle1.layEgg()
myEagle1.soar()


let myPenguin1 = Penguin1()
myPenguin1.layEgg()
myPenguin1.swim()
//myPenguin1.fly()     // 더이상 펭귄이 날지 않음


let myPlane1 = Airplane1()
//myPlane1.layEgg()         // 더이상 비행기가 알을 낳지 않음
myPlane1.fly()


let museum1 = FlyingMuseum1()
museum1.flyingDemo(flyingObject: myEagle1)
//museum1.flyingDemo(flyingObject: myPenguin1)   // 더이상 "CanFly"자격증이 없는 펭귄은 날지 못함
museum1.flyingDemo(flyingObject: myPlane1)











protocol SomeProtocol {
    func playPiano()
}

// 구조체에서 채택
struct MyStruct: SomeProtocol {
    func playPiano() {
        // 구체적인 구현
    }
}

// 클래스에서 채택
class MyClass: SomeProtocol {
    func playPiano() {
        // 구체적인 구현
    }
}

// 쉼표 앞은 상속할 클래스
//class MyClass: Aclass, SomeProtocol {
//    func playPiano() {
//        // 구체적인 구현
//    }
//}



