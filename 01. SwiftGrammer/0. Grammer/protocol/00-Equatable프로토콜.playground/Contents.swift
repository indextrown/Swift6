/*

 심화내용(외우지 않고 필요할 때 찾아보기)
 /**==========================================================
  - 1) Equatable : ==, != 비교 연산자 관련 프로토콜
  - 2) Comparable : < 연산자 관련 프로토콜 (>, <=, >=)
  - 3) Hashable : hash값을 갖게되어 값이 해셔블(값이 유일성을 갖게됨)해짐
  ============================================================**/

 
 주요 프로토콜
 - Equatable
 - Comparable
 - Hashable
 
 
 Equatable
 https://swiftdoc.org/v3.0/type/int/hierarchy/
 - 동일성을 비교하기위한 프로토콜(미리 채택을 해서 구현되어짐)
 - == !=
 - 연산자도 메서드이다
 - !=, == 연산자, 메서드를 이미 구현해둬서 같은지 다른지 판별이 가능했던것
 
 
 Comparable
 - 크기비교, 순서 즉 정렬이 가능해짐
 - Int, Double< String
 
 Hashable
 -
 
 
 */



// Int, Double, Sting 타입들은 이미 애플이 같은지 아닌지 뿐만 아니라 순서를 비교하는 방법도 구현해두었다
let num1: Int = 123
let num2: Int = 456

num1 == num2
num1 != num2

let str1: String = "Hello"
let str2: String = "안녕"

str1 == str2
str1 != str2


// 애플이 만든 타입이 아닌 개발자가 만든 타입, enum, struct, class 에서는 연산자가 구현되어있지않음
// 연산자를 직접 만들아보자


/**=======================================================================
 원칙) 구조체, 열거형의 경우 Equatable 프로토콜 채택시 모든 저장 속성(열거형은 모든 연관값)이
      Equatable 프로토콜을 채택한 타입이라면 비교연산자 메서드 자동구현
 예외) 1) 클래스는 인스턴스 비교를 하는 항등연산자(===)가 존재하기 때문에 비교연산자(==)
         구현방식에 대해 개발자에게 위임 (클래스는 원칙적으로 동일성(==) 비교 불가)
      2) 열거형의 경우 연관값이 없다면 기본적으로 Equatable/Hashable하기 때문에
         Equatable 프로토콜을 채택하지 않아도 됨
==========================================================================**/


// Equatable 즉 동일성을 비교하기위한 자격즉을 채택해야함
//enum Direction: Equatable {
//    case east
//    case west
//    case south
//    case north
//    
//    static func == (lhs: Direction, rhs: Direction) -> Bool {
//        return
//    }
//}



// 채택을 하지 않아도 동일성을 판별해준다!
// 이유: 최소한 동등함도 비교할 수 없다면 열거형을 구현하는 것은 너무 불편해짐, 구현할때마다 Equatable채택, 타입메서드 구현하면 개발자 입장에서 불편함 ==> 예외적으로 애플이 자동으로 구현해준것이다
// MARK: - 간단한 열거형인 경우 애플이 자동으로 구현해준다
enum Direction {
    case east
    case west
    case south
    case north
}

Direction.north == Direction.east
Direction.north != Direction.east


// MARK: - 연관값이 있는 경유(구체적인 값이 있는 경우) -> Equatable 없으면 판별 불가
// MARK: - 타입 메서드는 구현안해도 판별 가능 -> 이유: 연관값들이 Int, Double,,,인데 이미 각각 Equatable 프로토콜을 채택해서
// MARK: - 연관값이 Equatable를 채택한 타입이라면 타입 메서드를 구현하지 않아도 된다
enum SuperComputer: Equatable{
    case cpu(core: Int, ghz: Double)
    case ram(Int)
    case hardDisk(gb: Int)
}


SuperComputer.cpu(core: 8, ghz: 3.5) == SuperComputer.cpu(core: 8, ghz: 3.5)
SuperComputer.cpu(core: 8, ghz: 3.5) != SuperComputer.cpu(core: 8, ghz: 3.5)






// MARK: - 구조체인경우
struct Dog {
    var name: String
    var age: Int
}

// MARK: - 채택을 해줘야 동일성 판별 가능
extension Dog: Equatable {
    // MARK: - 원칙적으로 타입메서드도 구현해야하는데 애플이 자동으로 구현해줌 -> 모든 저장속성이 이미 Equatable 프로토콜 채택한 저장속성이라면!
    static func ==(lhs: Dog, rhs: Dog) -> Bool {
        return lhs.name == rhs.name && lhs.age == rhs.age
    }
}


let dog1: Dog = Dog(name: "초코", age: 10)
let dog2: Dog = Dog(name: "보리", age: 2)

dog1 == dog2
dog1 != dog2


// MARK: - 클래스인경우
class Person {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

// MARK: - Equatable채택, 타입메서드 구현 둘다 필요
// MARK: - 클래스의 인스턴스는 heap에 저장되고, heap에 저장된 인스턴스가 같은지 다른지 비교시 항등연산자(===)로 비교
// MARK: - 클래스는 원칙적으로 동일성을 비교하는게 불가능하다, 동일성 비교에 대한 내부적인 구현 논리를 개발자가 직접 구현해야 한다
extension Person: Equatable {
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name && lhs.age == rhs.age
    }
}
