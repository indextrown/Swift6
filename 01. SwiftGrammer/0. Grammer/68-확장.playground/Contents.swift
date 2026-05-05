
/*
 (119강)
 
 상속
 상위클래스의 모든 멤버를 자동으로 가져온다
 
 소급 모델링
 애플이 만들어둔것을 확장해서 쓸수있는 개념이다
 
 */



// 기존 타입
// orinal타입 = 본체
struct SomeType {
    
}

// 확장되기 전에 생성된 경우
// 메서드를 아래에 정의하더라도 코드를 다 읽기 때문에 doSomething실행가능하다...
// 코드가 아래에서 정의되어도 SomeType와 합쳐진다고 생각하자
var a = SomeType()
a.doSomething()

// 확장 extension
// (struct, class, enum 가능)
// 확장타입
extension SomeType {
    func doSomething() {
        print("Do something")
    }
}

// 기존 유형에 새 기능을 추가하기 위해 확장을 정의하면
// 확장이 정의되기 전에 생성된 경우에도 기존 인스턴스에서 새 기능을 사용 가능함






class Person {
    var id = 0
    var name = "이름"
    var email = "1234@gmail.com"
    
    func walk() {
        print("사람이 걷는다.")
    }
}


class Student: Person {
    var studentId = 1
    
    override func walk() {
        print("학생이 걷는다.")
    }
    
    func study() {
        print("학생이 공부한다.")
    }
}


extension Student {  // 스위프트에서는 확장에서 구현한 메서드에 대한 재정의가 불가 ⭐️ (@objc 붙이면 가능)
    func play() {
        print("학생이 논다.")
    }
}


class Undergraduate: Student {
    var major = "전공"
    
    override func walk() {
        print("대학생이 걷는다.")
    }
    
    override func study() {
        print("대학생이 공부한다.")
    }
    
    func party() {
        print("대학생이 파티한다.")
    }
    
    // func play()
    
//    override func play() {     // 스위프트에서는 확장에서 구현한 메서드에 대한 재정의가 불가 ⭐️
//        print("대학생이 논다.")
//    }
}


// 문법적으로 소급 모델링이라고 한다
extension Int {
    var squared: Int {
        return self * self
    }
}

10.squared
