import UIKit

/*
 
 swift
 - 객체지향
 - 프로토콜지향
 - 함수형
 
 프로토콜 확장의 적용 제한
 
 
 */

protocol Remote {
    func turnOn()
    func turnOff()
}

// 프로토콜 확장에서 메서드들에 대한 기본적인 구현을 제공할수 있다
// 채택한 곳에서 구현을 안하면 기본 구현을 사용 가능하다
extension Remote {
    // 기본구현
    func turnOn() { print("리모콘 켜기") }
    func turnOff() { print("리모콘 끄기") }
}

// 프롬포트 확장시 형식을 제한 가능하다
protocol Bluetooth {
    func blueOn()
    func blueOff()
}

// Self: 해당 타입을 의미한다
// self: 타입 내부에 쓰이면서 인스턴스 자신을 의미한다
// 여기서 Self는 Bluetooth를 채택한 스마트폰이 된다
// where~: Remote 프로토콜을 채택한 경우에만 Bluetooth확장이 적용이 된다
extension Bluetooth where Self: Remote {
    func blueOn() { print("블루투스 켜기") }
    func blueOff() { print("블루투스 끄기") }
}

class SmartPhone: Remote, Bluetooth {
    
}

// Self: Ipad 클래스를 의미한다
class Ipad: Remote, Bluetooth {
    
}
