import UIKit


struct Dog {
    var name: String = ""
    var weight: Int = 0
    var height: Int = 0
    
}

// 1) 멤버와이즈 이니셜라이저(구조체는 자동으로 자공)
// Dog(name: <#T##String#>, weight: <#T##Int#>, height: <#T##Int#>)

// 2) 기본생성자도 제공(기본값이 있을 때)
// Dog()

// 3) height의 기본 값을 지우면 어떤 생성자가 제공될까
// Dog(height: <#T##Int#>)

// 어떤 값이 없다면 그것만 매개변수로 할당하도록 생성자를 제공한다
// 전제조건: 개발자가 직접 구현하지 않아야 한다
Dog(height: 10)
Dog(name: "kim", weight: 70, height: 174)




/*
 
 클래스
 - 기본생성자 제공
 
 구조체
 - 기본생성자 제공
 - 멤버와이즈 이니셜라이저 기본 제공
 - 일부 저장속성이 기본값이 없으면 해당 값을 파라미터로 받는 생성자 제공
 
 구조체 확장
 - 지정생성자의 형태로도 자유롭게 생성자 구현 가능
 - 모든 저장속성에 기본값이 있고 + 본체에서 생성자 구현 안한 경우
 - 구조체에 생성자를 구현을 했다고 하더라도 본체에서 기본생성자/멤버와이즈이니셜라이저 제공됨
 
 */

extension Dog {
    init(name: String) {
        self.name = name
    }
}

// 원칙적으로 생성자를 개발자가 구현을 했으니까 아래의 생성자 제공안되는게 맞음
// 예외적으로 제공됨
// 구조체의 확장에서 개발자가 직접적으로 구현해줘도 본체에 구현 안해주면 기본생성자 + 멤버와이즈 생성자 제공해줌
Dog(height: 10)
Dog(name: "kim", weight: 70, height: 174)
Dog(name: "Index")
