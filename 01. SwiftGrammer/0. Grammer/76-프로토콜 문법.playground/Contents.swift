import UIKit

// 1) 프로토콜의 정의
protocol Myprotocol {   // 최소한 요구사항 나열
    func doSomething() -> Int
}

class FamilyClass {}

// 2) 프로토콜 채택
class MyClass: FamilyClass, Myprotocol {
    // 3) 속성/ㅁ[서드 포함 구체적인 구현
    func doSomething() -> Int {
        return 7
    }
}

/*=================================================*/
// 속성의 요구사항 종류
// 프로토콜 속성의 요구사항
/*
 - 속성의 뜻에서 var로 선언(let으로 선언할 수 없음)
 - get, set 키워드를 통해서 읽기/쓰기 여부를 설정(최소한의 요구사항일뿐)
 - 저장 속성/ 계산 속성으로 모두 구현 가능
 */

// protocol은 자격증이다
// 최소한의 요구사항을 나열하는 것이다
protocol RemoteMouse {
    // 기본값 넣을 수 없다
    // 채택해서 구현 ===> let 저장속성을 선언 가능 이유: get은 최소한 읽기 가능해야함
    // var저장속성도 가능(읽기/쓰기가능)
    // 읽기계산속성
    // 읽기, 쓰기 계산속성
    var id: String { get }               // let 저장속성 / var 저장속성 / 읽기계산속성 / 읽기, 쓰기 계산속성
    var name: String { get set }         // var 저장속성 / 읽기, 쓰기 계산속성 / 최소한 get, set으로 구현해야해
    static var type: String { get set }  // 타입 저장 속성(static)
}                                        // 타입 계산 속성(class)
    // 여기서 static키워드 의미: 타입속성으로 구현 해야한다는 의미, !!!주의: class로 할 수 없다 이런 의미는 절대 아님!!!

struct TV: RemoteMouse {
    // 저장속성
    //let id: String = "456"
    
    // 읽기 계산속성
//    var id: String {
//        return "안녕하세요"
//    }
    
    // 읽기/쓰기 계산속성
    var id: String {
        get {
            return "안녕하세요"
        }
        set {
            
        }
    }
    
    var name: String = "삼성티비"
    static var type: String = "리모콘"
}



class SmartPhone: RemoteMouse {
    var id: String {
        return "777"
    }
    
    var name: String {
        get {"아이폰"}
        set {}
    }
    
    // 타입 저장 속성
    // 저장 속성은 원칙적으로 재정의가 불가능해서 class키워드를 사용할 수 없고 static 키워드만 사용가능
    static var type: String = "리모콘"
}


class Ipad: RemoteMouse {
    var id: String = "777"
    var name: String = "아이패드"
    
    // 타입 계산 속성 = 실질적인 메서드
    // 하위의 타입에서 재정의가 가능하다
    // 즉 class로 선언 가능
    class var type: String {    // 타입 계산 속성은 재정의 가능 (class 키워드 가능)
        get {"리모콘"}
        set {}
    }
    
}
