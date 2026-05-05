import UIKit

/*
 
 (129강)
 서브스크립트(=메서드) 요구사항
 - get, set 키워드 써서 읽기/쓰기 여부를 설정(최소한의 요구사항일뿐)
 - get 키워드 ==> 최소한 읽기 서브스크립트 구현 / 읽기, 쓰기 모두 구현 가능
 - get/set키워드 둘다쓰면 ==> 반드시 읽기, 쓰기 모두 구현해야함
 
 */

// 프로토콜 정의
protocol DataList {
    // 서브스크립트 문법에서 get 필수   (set 선택)
    subscript(idx: Int) -> Int { get }
}


struct DataStructure: DataList {
    // 1) get만 있는 경우 get 블록 생략 가능
//    subscript(idx: Int) -> Int {
//        return 0
//    }
    
    // 2)
//    subscript(idx: Int) -> Int {
//        get {
//            return 0
//        }
//    }
    subscript(idx: Int) -> Int {
        get {
            return 0
        }
        set {       // 구현은 선택
            // 상세구현 생략
        }
    }
}


protocol Cartificate {
    func doSomethihg()
}


class Person {
    
}

// 관습적으로 본체보다는 확장에서, 채택 구현(코드의 깔끔한 정리 가능)
// 확장에서 구현한 메서드는 아래의 클래스에서 재정의 할수없다(참고만)
extension Person: Cartificate {
    func doSomethihg() {
        print("Do something")
    }
}

