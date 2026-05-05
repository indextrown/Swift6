import UIKit

/*
 
 (132강)
 프로토콜의 선택적(Optinal) 요구사항의 구현
 - 채택한 곳에서 요구사항을 선택적으로 구현 가능하다??
 
 어트리뷰트
 컴파일러에게 알려주는 특별한 신호이자, 추가적인 정보를 제공
 
 어트리뷰트(2가지 종류)
 @available, @obje, @escaping, @IBOutlet, @IBAction
 
 어트리뷰트(2가지 종류)
 1) 선언에 대한 추가정보 제공
 2) 타입에 대한 추가정보 제공
 
 사용방법
 @어트리뷰트이름 ===> @available
 @어트리뷰트이름(아규먼트) ===> @available(iOS *)
 
 
 objc 어트리뷰트키워드는
 스위프트로 작성한 코드를 objective-c코드에서도 사용할 수 있게 해주는 어트리뷰트(속성)이다
 프로토콜에서 요구사항 구현시, 반드시 강제하는 멤버가 아니라 선택적인 요구사항으로 구현할때 사용한다
 프로토콜 앞에는 @objc추가
 멤버 앞에는 @objc optional을 모두 추가
 
 선택적 멤버를 선언한 프로토콜 구현시
 오브젝티브-c에서는 클래스 전용 프로토콜임(구조체, 열거형 채용/채택 불가)
 오브젝티브-c는 구조체와 열거형에서 프로토콜 채택을 지원하지 않음
 
 */



// iOS버전 10이상만 적용되는 클래스이다
// macOS에서는 10.12버전 이상에만 적용되는 클래스다
@available(iOS 10.0, macOS 10.12, *)
class SomeType {
    
}

// 프로토콜 자체도 objc로 선언해야함 즉 object-c에서 읽을 수 있는코드여야함
// 속성에도 objc붙이고 optional 붙여줘야함
// 외우는것임 문법적 약속임
// object-c에서는 선택적인 멤버를 구현하는게 당연했기 때문에 그 기능을 가져와서 도입햇서 쓰는것임

// 선택적인 멤버를 어떻게 선언하는가
@objc protocol Remote {
    // optional: 선택적인 멤버
    // 이 속성은 채택을 하는 곳에서 구현을 해도되고 안해도됨
    @objc optional var isOn: Bool { get set }
    func turnOn()
    func turnOff()
    @objc optional func doNeflix()
}

class TV: Remote {
//    var isOn: Bool = false
    func turnOn() {}
    func turnOff() {}
}

