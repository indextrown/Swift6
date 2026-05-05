/*
 
 (192강)
 접근 제어
 
 디버그: command + shift + y

 
 [접근 수준(Access Levels)]
 - 1) open        - 다른 모듈에서도 접근가능 / 상속 및 재정의도 가능 (제한 낮음)
 - 2) public      - 다른 모듈에서도 접근가능(상속/재정의불가)
 - 3) internal    - 같은 모듈 내에서만 접근가능(디폴트)
 - 4) fileprivate - 같은 파일 내에서만 접근가능
 - 5) private     - 같은 scope내에서만 접근가능                (제한 높음)
 
 - 모듈(module): 프레임워크, 라이브러리, 앱 등 import해서 사용할 수 있는 외부의 코드
 
 */

// 따로 명시하지 않으면 internal 설정임(디폴트)
// 모듈(프레임워크나 라이브러리)을 만들어서 배포하려면, public이상으로 선언해야함


// 접근 제어를 가질 수 있는 요소는
// (스위프트 문서 - 엔터티 / 독립된 개체)
// 1) 타입(클래스/구조체/열거형/스위프트 기본타입 등)
// 2) 변수/속성
// 3) 함수/메서드(생성자, 서브스크립트 포함)
// 4) 프로토콜도 특정영역으로 제한될 수 있음


/**================================================
 - 클래스의 접근수준을 가장 넓히면 - open / 구조체 - public
 - 1) 클래스 - open (상속, 재정의와 관계)
 - 2) 구조체 - public (구조체는 어짜피 상속이 없기 때문)
===================================================**/


import UIKit


class SomeClass {
    private var name = "이름" // 내부적으로만 사용하겠다
    var age = 25 // 기본으로 internal 되어있음
    
    func nameChange(name: String) {
        if name == "길동" {
            return
        }
        self.name = name
    }
    
    func selfName() -> String {
        return self.name
    }
}

let obj1 = SomeClass()
//obj1.name
//obj1.name = "홍길동"

obj1.nameChange(name: "민영")
print(obj1.selfName())



// MARK: - 타입은 타입을 사용하는 변수(속성)나, 함수(메서드)보다 높은 수준으로 선언되어야함
var some: String = "접근가능"        // String은 public으로 설정되있음
var some2: String = "접근가능"       // 변수는 internal로 기본 설정 되있음
// open var some3: String = "접근가능"  // 변수가 너무 넓게 선언되어 있음 -> 컴파일 에러

// 기본적으로 internal
// 구조체들은 public로 설정되있음
func someFunction(a: Int) -> Bool {
    return true
}


class Someclass {
    // 감추기
    private var _name = "이름"
    
    // 읽기만 가능하도록 지정가능, 쓰기에 대한 제약을 둠
    var name: String {
        return _name
    }
    
    // 쓰기 함수
    func changeName(name: String) {
        self._name = name
    }
}

let a = Someclass()
a.changeName(name: "Index")


// 이름을 세팅할때만 private, 읽을때는 internal 지정
class Someclass2 {
    private(set) var name = "이름" // 읽기: internal / 쓰기: private
    
}

let ab = Someclass2()
// ab.name           // get  internal
// ab.name = "Index" // set  private
