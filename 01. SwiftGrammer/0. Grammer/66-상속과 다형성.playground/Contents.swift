/*
 
 (117강)
 상속과 다형성(Polymorphism=여러가지 모양)
 
 다형성
 - 하나의 객체(인스턴스)가 여러가지의 타입의 형태로 표현할 수 있음을 의미
 - 또는 하나의 타입으로 여러 종류의 객체를 여러가지 형태(모습)로 해석할 수 있는 성격
 - 다형성이 구현되는 것은 "클래스의 상속" 과 같은 연관이 있음
 
 객체지향
 - 캡슐화(은닉화)
 - 상속
 - 추상화
 - 다형성
 
 */

// 저장속성이 기본값이 다 있어서 생성자 만들 필요 x
class Person {
    var id = 0
    var name = "이름"
    var email = "123@gmail.com"
    
    func walk() {
        print("사람이 걷는다.")
    }
}

class Student: Person {
    // id
    // name
    // email
    var studentID = 1
    
    // 재정의
    override func walk() {  // 재정의 메서드, walk() - 1
        print("학생이 걷는다.")
    }
    
    func study() {
        print("학생이 공부한다.")
    }
}


class Undergraduate: Student {
    // id
    // name
    // email
    // studentId
    var major = "전공"
    
    override func walk() {      // 재정의 메서드, walk() - 2
        print("대학생이 걷는다.")
    }
    
    override func study() {     // 재정의 메서드, study() - 1
        print("대학생이 공부한다.")
    }
    
    func party() {
        print("대학생이 파티한다.")
    }
}


let person1 = Person()
person1.walk()

//let student1 = Student()
let student1: Person = Student()    // 업캐스팅
student1.walk()
//student1.study()                    // 업캐스팅하면 Person에 구현된 속성/메서드만 접근가능하다

//let undergraduate1 = Undergraduate()
let undergraduate1: Person = Undergraduate() // 업캐스팅
undergraduate1.walk()
//undergraduate1.study()                // 업캐스팅하면 Person에 구현된 속성/메서드만 접근가능하다
//undergraduate1.party()                // 업캐스팅하면 Person에 구현된 속성/메서드만 접근가능하다


// 업캐스팅 하더라도 실제로 힙의 메모리 공간에는 저장속성이 존재하더라도 해당 변수에서 접근할 수 있는 것은 Person이다
// 대학생 붕어빵을 찍어내고 Person타입으로 인식 하더라도 실제로는 대학생 붕어빵과 관련된 대학생이 걷는다 라는 메서드를 출력을 하게 되어 있다
 

let people: [Person] = [Person(), Student(), Undergraduate()]

// 반복문
for person in people {
    person.walk()
}
