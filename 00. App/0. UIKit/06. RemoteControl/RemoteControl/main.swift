//
//  main.swift
//  RemoteControl
//
//  Created by 김동현 on 2/15/25.
//

// MARK: - 델리게이트 패턴: 객체와 객체간의 커뮤니케이션을 돕는 패턴
// MARK: - 중간에 대리자(프로토콜 타입으로 설정)를 두어 커뮤니케이션 돕는다

import Foundation

// 자격증(정의) (텍스트필드 프로토콜)
protocol RemoteControlDelegate {
    func channelUp()
    func channelDown()
}

// 리모콘 클래스(텍스트필드의 역할 - 직접적으로 유저와 커뮤니케이션)
class RemoteControl {
    
    // 델리게이트 속성: 프로토콜 타입으로 정의
    // 대리자: RemoteControlDelegate를 채택한 타입이면 모두 성립
    var delegate: RemoteControlDelegate? // MARK: - 삼성티비 들어감
    
    func doSomething() {
        print("리모콘의 조작이 일어나고 있음")
    }
    
    // 대리자(samsungTV)의 channelUp 호출
    func channelUp() { // 어떤 기기가 리모콘에 의해 작동되는지 몰라도 된다
        delegate?.channelUp() // MARK: - 삼성티비 채널up
    }
    
    // 대리자(samsungTV)의 channelDown 호출
    func channelDown() {       // MARK: - 삼성티비 채널Down
        delegate?.channelDown()
    }
}

// TV클리스 뷰컨트롤러의 역할 - 리모콘과 커뮤니케이션
class TV: RemoteControlDelegate {
    func channelUp() {
        print("TV의 채널이 올라간다. ")
    }
    
    func channelDown() {
        print("TV의 채널이 내려간다. ")
    }
}

class SmartPhone: RemoteControlDelegate {
    
    init(remote: RemoteControl) {
        remote.delegate = self
    }
    
    func channelUp() {
        print("스마트폰의 채널이 올라간다. ")
    }
    
    func channelDown() {
        print("스마트폰의  채널이 내려간다. ")
    }
}

// 1)
let remote = RemoteControl()
let samsungTV = TV()
remote.delegate = samsungTV // MARK: - 대리자를 samsungTV를 설정해준다는 의미
// remote.delegate = self   // MARK: - 객체 네에 있으면 self
remote.channelUp ()
remote.channelDown ()


// 2)
let smartPhone = SmartPhone(remote: remote)
remote.channelUp()
remote.channelDown()
