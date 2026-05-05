/*
 
 (184강)
 
 
 

 */

// 빈 문자열 생성(정수는 불가)
struct Member {
    var members: [String] = []
}

struct GenericMember<T> {
    var members: [T] = []
}


// GenericMember()             MARK: 기본생성자 제공
// GenericMember(members: <#T##[T]#>) MARK: 멤버와이즈 이니셜라이저 제공

var member1 = GenericMember(members: ["jobs", "cook", "musk"])
// MARK: 붕어빵을 찍어내는 순간에 변수의 타입이 정해지기 때문에 즉 메모리 형태가 결정되기 떄문에 다른 타입형태를 담을 수 없다
// member1 = GenericMember(members: [1, 2, 3])

var member2 = GenericMember(members: [1, 2, 3])


class GridPoint<A> {
    var x: A
    var y: A
    
    init(x: A, y: A) {
        self.x = x
        self.y = y
    }
}

let aPoint = GridPoint(x: 10, y: 10)
let bPoint = GridPoint(x: 10.4, y: 20.5)


// 열거형에서 연관값을 가질 때 제네릭으로 정의가능
// 어차피 케이스는 자체가 선택항목중에 하나일 뿐(독립타입)이고 그것을 타입으로 정의할 일은 없음
enum Pet<T> {
    case dog // 타입으로 정의할일 없음
    case cat
    case etc(T) // 연관값(구체적인 값)을 가질때만 제네릭으로 정의할 수 있다
}

/*
 MARK: 연관값이란 구체적인 값을 가질때만 제네릭으로 정의하는것
 */



let animal = Pet.etc("고슴도치")
let animal2 = Pet.etc(30)

// 제네릭 구조체의 확장
// 좌표
struct Coordinate<T> {
    var x: T
    var y: T
}

// MARK: 확장을 할때는 extension Coordinate뒤에 <T> 안쓴다
extension Coordinate {
    // 튜플로 리턴하는 메서드
    func getPlace() -> (T, T) {
        return (x, y)
    }
}

let place = Coordinate(x: 5, y: 5)
print(place.getPlace())

// 확장에 where절 추가 가능
// 정수형인 경우에만 메서드 구현됨
extension Coordinate where T == Int {
    
    // 배열로? 리턴하는 메서드
    func getArray() -> [T] {
        return [x, y]
    }
}

let place2 = Coordinate(x: 3, y: 5).getArray()
print(place2)

//let print3 = Coordinate(x: 3.5, y: 3.5).getArray()  // getArray() 없음





/**==================================================================
 - 제네릭에서 타입을 제약할수 있음
 - 타입 매개 변수 이름 뒤에 콜론으로 "프로토콜" 제약 조건 또는 "단일 클래스"를 배치 가능
 - (1) 프로토콜 제약 <T: Equatable>
 - (2) 클래스 제약 <T: SomeClass>
====================================================================**/



// Equatable 프로토콜을 채택한 타입만 해당 함수에서 사용 가능 하다는 제약
// MARK: Equatable 프로토콜을 채택한 타입만 가능하다는(이 함수에서 타입으로 작동할 수 있다는) 의미이다
func findIndex<T: Equatable>(item: T, array:[T]) -> Int? {     // <T: Equatable>
    for (index, value) in array.enumerated() {
        if item == value {
            return index
        }
    }
    return nil
}


let aNumber = 5
let someArray = [3, 4, 5, 6, 7]

if let index = findIndex(item: aNumber, array: someArray) {
    print("밸류값과 같은 배열의 인덱스: \(index)")
}



// 클래스 제약의 예시


class Person {}
class Student: Person {}

let person = Person()
let student = Student()



// 특정 클래스와 상속관계에 내에 있는 클래스만 타입으로 사용할 수 있다는 제약  (구조체, 열거형은 사용 못함)
// (해당 타입을 상속한 클래스는 가능)

func personClassOnly<T: Person>(array: [T]) {
    // 함수의 내용 정의
}


personClassOnly(array: [person, person])
personClassOnly(array: [student, student])

personClassOnly(array: [Person(), Student()])




/*:
 ---
 * 반대로 구체/특정화(specialization) 함수구현도 가능
 ---
 */
/**=================================================================================
 - 항상 제네릭을 적용시킨 함수를 실행하게만 하면, 또다른 불편함이 생기지 않을까?
 - (제네릭 함수가 존재하더라도) 동일한 함수이름에 구체적인 타입을 명시하면, 해당 구체적인 타입의 함수가 실행됨
 ===================================================================================**/


// 문자열의 경우, 대소문자를 무시하고 비교하고 싶어서 아래와 같이 구현 가능 ⭐️
// 위의 findIndex<T: Equatable>(item: T, array:[T]) -> Int? 와 완전 동일

//func findIndex(item: String, array:[String]) -> Int? {
//    for (index, value) in array.enumerated() {
//        if item.caseInsensitiveCompare(value) == .orderedSame {
//            return index
//        }
//    }
//    return nil
//}



let aString = "jobs"
let someStringArray = ["Jobs", "Musk"]


if let index2 = findIndex(item: aString, array: someStringArray) {
    print("문자열의 비교:", index2)
}




