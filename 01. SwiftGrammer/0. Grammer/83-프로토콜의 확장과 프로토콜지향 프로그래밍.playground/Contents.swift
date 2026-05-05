import UIKit

// 프로토콜 정의
protocol Remote {
    
    func turnOn()
    func turnOff()
}

class TV1: Remote {
    // 실제 구현시 우선순위
//    func turnOn() { print("TV 켜기") }
//    func turnOff() { print("리모콘 끄기") }
    
    // 우선순위가 아닌 타입에 따른 선택
    func doAnotherAction() {
        print("TV 또 다른 동작")
    }
}

struct Aircon1: Remote {
    func turnOn() { print("리모콘 켜기") }
    func turnOff() { print("리모콘 끄기") }
}

// 동일한 구현 내용을 코드를 반복해서 쓰는 행위 불편함
// 이를 해결하기 위해 프로토콜의 확장 개념 존재
class HomePot: Remote {
    func turnOn() { print("리모콘 켜기") }
    func turnOff() { print("리모콘 끄기") }
}

// 프로토콜의 확장
// 프로토콜의 확장에서는 기본(디폴트)구현 제공해준다
// 채택을 할때마다 메서드를 구현해야되는 귀찮은 경우를 예방하기위해 프로토콜 확장에서 기본 구현을 제공한다
extension Remote {
    func turnOn() { print("리모콘 켜기") }
    func turnOff() { print("리모콘 끄기") }
    
    func doAnotherAction() {
        print("리모콘 또 다른 동작")
    }
}

var tv7 = TV1()
tv7.turnOn()
tv7.turnOff()
tv7.doAnotherAction()


var tv8: Remote = TV1()
tv8.doAnotherAction()




/*
 
 class와 관련된 메서드 테이블 = virtual table라고 부른다
 이 virtual table은 메서드 주소를 저장하고 있음
 
 클래스에서 상속시 메서드 테이블을 만든다
 메서드 테이블은 구체적으로 virtual table라고 부른다
 클래스에서 프로토콜을 채택을 하게되면 추가적으로 프로토콜 테이블도 만든다
 클래스에 관련된 붕어빵을 찍어낼때 클래스로 저장되어있으면 원래 메서드 테이블 사용하고 프로토콜로 저장되어있으면 프로토콜테이블 즉 withness table를 사용해서 어떤 메서드를 실행시킬지 찾아거서 실행시키는 개념이다
 
 withness table
 - 개발자가 테이블 만들면 우선순위 테이블로 만들어짐
 - 구현안하면 기본 구현으로 제공되는 테이블을 쓰게된다
 - 요구사항에서 요구하고 있는 메서드가 아니라 확장에서 메서드를 추가하면 direct d ispatch라고 하는데 실제로 코드에 메서드 주소를 심어버린다
 - 즉 다른말로 하자면 구조체는 원래부터 direct dispatch로 동작한다
 -> 메서드 자리에 코드를 심어버린다, 프로토콜도 코드를 심어버린다
 - 클래스는 vtable을 이용한다
 -> 클래스와 구조체는 다른 방식으로 동작한다
 
 
 */


class Ipad: Remote {
    func turnOn() { print("아이패드 켜기") }
    func doAnotherAction() { print("아이패드 다른 동작") }
}

/**=================================================
 [Class Virtual 테이블]
 - func turnOn()          { print("아이패드 켜기") }
 - func turnOff()         { print("리모콘 끄기") }
 - func doAnotherAction() { print("아이패드 다른 동작") }
====================================================**/


let ipad: Ipad = Ipad()
ipad.turnOn()           // 클래스 - V테이블
ipad.turnOff()          // 클래스 - V테이블
ipad.doAnotherAction()  // 클래스 - V테이블

// 아이패드 켜기
// 리모콘 끄기
// 아이패드 다른 동작



/**=====================================
 [Protocol Witness 테이블] - 요구사항
 - func turnOn()  { print("아이패드 켜기") }
 - func turnOff() { print("리모콘 끄기") }
========================================**/


let ipad2: Remote = Ipad()
ipad2.turnOn()           // 프로토콜 - W테이블
ipad2.turnOff()          // 프로토콜 - W테이블
ipad2.doAnotherAction()  // 프로토콜 - Direct (직접 메서드 주소 삽입)

// 아이패드 켜기
// 리모콘 끄기
// 리모콘 또 다른 동작


// 구조체 ⭐️ ==================================================

struct SmartPhone: Remote {
    func turnOn() { print("스마트폰 켜기") }

    func doAnotherAction() { print("스마트폰 다른 동작") }
}


/**=====================================
 [구조체] - 메서드 테이블이 없음
========================================**/


// 본래의 타입으로 인식했을때
var iphone: SmartPhone = SmartPhone()
iphone.turnOn()             // 구조체 - Direct (직접 메서드 주소 삽입)
iphone.turnOff()            // 구조체 - Direct (직접 메서드 주소 삽입)
iphone.doAnotherAction()    // 구조체 - Direct (직접 메서드 주소 삽입)

// 스마트폰 켜기
// 리모콘 끄기
// 스마트폰 다른 동작

