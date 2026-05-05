import UIKit

/*
 
 (130강)
 ###프로토콜은 타입이다###
 스위프트는 프로토콜을 "일급객체"로 취급한다 = 타입으로 사용 가능하다
 - 프로토콜을 변수에 할당할 수 있음
 - 함수를 호출할때, 프로토콜을 파라미터로 전달할 수 있음
 - 함수에서 프로토콜을 반환할 수 있음
 is
 타입을 확인하는 타입 체크 오퍼레이터
 as
 타입 캐스팅이 가능한지(업/다운) 확인하는 연산자
 
 
 is연산자 => 특정 타입이 프로토콜 채택하고 있는지 확인(참 또는 거짓) 그 반대도 확인가능
 as연산자 => 타입 캐스팅 (특정 인스턴스를 프로토콜로 변환하거나, 프로토콜을 인스턴스 실제형식으로 캐스팅)
 */


// 프로토콜은 ===> first class citizen(일급객체)이기 떄문에, 타입(형식)으로 사용가능
protocol Remote {
    func turnOn()
    func turnOff()
}

class TV: Remote {
    func turnOn() {
        print("TV켜기")
    }
    func turnOff() {
        print("TV끄기")
    }
}

struct SetTopBox: Remote {
    func turnOn() {
        print("셋톱박스켜기")
    }
    func turnOff() {
        print("셋톱박스끄기")
    }
    func doNerflix() {
        print("넷플릭스 보기")
    }
}

// tv인스턴스를 찍어냄 타입: TV
let tv: TV = TV()
let sbox: SetTopBox = SetTopBox()

// 업캐스팅 즉 프로토콜 타입으로 저장 가능
// 프로토콜 타입으로 저장하면 프로토콜에서 선언하고 있는 메서드만 호출 가능해진다
let tv2: Remote = TV()
tv2.turnOn()
tv2.turnOff()
 
// 다운캐스팅 성공하면 TV 켜기
(tv2 as? TV)?.turnOn()
(tv2 as! TV).turnOn() // !: 강제로 캐스팅

// 프로토콜 타입 취급의 장점
let electronic: [Any] = [tv, sbox]
let electronic2: [Remote] = [tv, sbox]

for item in electronic2 {
    item.turnOn()
}

// 함수의 타입으로도 프로토콜 사용가능
func turnOnSomeElectronics(item: Remote) {
    item.turnOn()
    print("완료")
}

turnOnSomeElectronics(item: tv)

// as연산자
// 프로토콜 타입으로 변환 후 newBox에 저장
// 업캐스팅(as)
let newBox = sbox as Remote
newBox.turnOff()
newBox.turnOn()

// 다운캐스팅
let sbox2 = electronic2[1] as? SetTopBox// 실패시 nil
sbox2?.doNerflix()// 접근연산자를 사용시 앞에 있는 것이 옵셔널이면 ?를 붙여야한다

// 업캐스팅
// 특정타입이 프로토콜을 채택하고 있는지 확인, 반대도 가능
tv is Remote        // 항상 참인 이유: 해당 프로토콜을 채택하기 떄문
sbox is Remote

// remote타입으로 저장된 것들을 구체적인 타입으로 확인 가능
electronic2[0] is TV
electronic2[1] is SetTopBox
electronic2[0] is SetTopBox

