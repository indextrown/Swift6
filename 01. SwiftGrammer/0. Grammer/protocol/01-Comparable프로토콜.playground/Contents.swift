/*
 
 (215강)
 Comparable 프로토콜
 - (크기)비교가능
 
 */

/**=========================================================
 - Comparable 프로토콜의 요구사항은
 - static func < (lhs: Self, rhs: Self) -> Bool 메서드의 구현
 
 - 일반적으로 < 만 구현하면 <, <=, >= 연산자도 자동 구현
 - Comparable 프로토콜은 Equatable프로토콜을 상속하고 있음
   (필요한 경우, 비교연산자(==)도 구현해야함)
 
 - 스위프트에서 제공하는 기본 숫자 타입 및 String은 모두 다 채택을 하고 있음
   (Bool타입은 채택하지 않음)
 ===========================================================**/

// Int, Double, Sting 타입들은 이미 애플이 같은지 아닌지 뿐만 아니라 순서를 비교하는 방법도 구현해두었다

let num1: Int = 123
let num2: Int = 456

num1 < num2
num1 > num2


let str1: String = "Hello"
let str2: String = "안녕"

str1 < str2
str1 > str2



/**=========================================================================
 원칙) 구조체, 클래스의 모든 저장 속성(열거형은 원시값이 있는 경우)이 Comparable을 채택한
      경우라도, <(less than)연산자 직접 구현해야함#####!
      (순서 정렬 방식에 대해서는 무조건 구체적인 구현이 필요하다는 논리)
 
 예외) 열거형의 경우, 원시값이 없다면(연관값이 있더라도) Comparable을 채택만 하면
      <(less than)연산자는 자동 제공
      (원시값을 도입하는 순간, 개발자가 직접 대응되는 값을 제공하므로 정렬방식도 구현해야한다는 논리)
============================================================================**/

enum Direction: Int {
    case east  // 0
    case west  // 1
    case south // 2
    case north // 3
}

extension Direction: Comparable {
    static func < (lhs: Direction, rhs: Direction) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

Direction.north < Direction.east // 3 < 0
Direction.north > Direction.east // 3 > 0


// MARK: - 구조체인경우
struct Dog {
    var name: String
    var age: Int
}

// MARK: - Comparable는 Equatable을 채택하고 있기 때문에 Equatable의 요구사항 == 을 구현해야함, 하지만 구조체의 경우에 저장속성이 Equatable 프로토콜을 채택하고 있으면 Equatable 메서드 == 를 자동으로 구현해주기 때문에 구현하지 않아도 된다
extension Dog: Comparable {
    static func < (lhs: Dog, rhs: Dog) -> Bool {
        return lhs.name < rhs.name
    }
}

let dog1: Dog = Dog(name: "초코", age: 10)
let dog2: Dog = Dog(name: "보리", age: 2)

dog1 < dog2
dog1 > dog2


// MARK: - 클래스인경우
class Person {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

// MARK: - 클래스의경우 == 자동구현안함, 클래스 인스턴스 비교는 ===임
// MARK: - 개발자에게 구현 논리를 위임함
extension Person: Comparable {
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name && lhs.age == rhs.age
    }
    
    static func < (lhs: Person, rhs: Person) -> Bool {
        return lhs.name < rhs.name
    }
}

