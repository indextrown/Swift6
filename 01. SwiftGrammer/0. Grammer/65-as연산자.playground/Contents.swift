/*
 
 (116강)
 as연산자
 1) 업캐스팅
 
 2) 다운캐스팅
 
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



/*
 붕어빵을 찍을떄 5개의 저장공간을 만든다
 저장할때만 person으로 저장한다
 실제로 메모리 공간은 5개지만 저장할때는 3개만 보이도록 한다
 Person타입으로 담는 것
 ===> 다운캐스팅
 
 !: 강제 다운 캐스팅
 */

let person: Person = Undergraduate()
person.id
person.name
person.email
// person.studentId
// person.major   // Value of type 'Person' has no member 'major'

// 다운캐스팅 /as!

// person이라는 인스턴스를 Undergraduate 타입으로 변환을 해서 ppt에 저장한다
// Optional Undergraduate타입!
let ppt: Undergraduate? = person as? Undergraduate

//if let pp = ppt {
//    pp.id
//}

//if let ppp = person as? Undergraduate {
//    ppp.id
//    ppp.name
//    ppp.email
//    ppp.studentId
//    ppp.major
//}





//let str: String = "hello"
//let otherStr = str as NSString // 가끔 사용해야함
//
