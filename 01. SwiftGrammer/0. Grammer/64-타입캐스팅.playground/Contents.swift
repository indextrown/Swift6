/*
 
 (115강)
 타입캐스팅
 
 is연산자 / as 연산자
 is연산자
 - 타입에 대한 검사를 하고 참이면 true 거짓이면 false 리턴해준다
 
 */

class Person {
    var id = 0
    var name = "이름"
    var email = "abc@gmail.com"
}

class Student: Person {
    // id
    // name
    // email
    var studentId = 1
}

class Undergraduate: Student {
    // id
    // name
    // studentId
    var major = "전공"
}

let person1 = Person()
person1.id
person1.email

let student1 = Student()
student1.id
student1.email
student1.studentId

let undergraduate1 = Undergraduate()
undergraduate1.id
undergraduate1.name
undergraduate1.email
undergraduate1.studentId
undergraduate1.major

/* is연산자(Type Check Operator)
 타입에 대한 검사를 수행하는 연산자
*/

// 사람 인스턴스는 학생/대학생 타입은 아니다. (사람 타입이다.)
person1 is Person                // true
person1 is Student               // false
person1 is Undergraduate         // false

// student 타입으로 찍어낸 인스턴스는 당연히 내부 관계가 person을 가지고 있기 때문에 student타입은 person타입이다
student1 is Person               // true
student1 is Student              // true
person1 is Undergraduate         // true

// 대학생 인스턴스는 사람이거나, 학생이거나, 대학생 타입 모두에 해당한다
undergraduate1 is Person         // true
undergraduate1 is Student        // true
undergraduate1 is Undergraduate  // true

/*
 대학생 타입의 인스턴스를 찍어내면 힙의 메모리에 다섯가지 항목이 저장속성으로 생긴다
 Person타입 O
 Student타입 O
 Undergraduate타입 O

*/

let person2 = Person()
let student2 = Student()
let undergraduate2 = Undergraduate()
let people = [person1, person2, student1, student2, undergraduate1, undergraduate2]

// 학생 인스턴스 개수를 세고 싶다
var studentNumber = 0

for someone in people {
    if someone is Student {
        studentNumber += 1
    }
}

print(studentNumber)



