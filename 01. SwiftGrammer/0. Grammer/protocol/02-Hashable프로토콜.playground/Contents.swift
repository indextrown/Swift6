/*
 
 (216강)
 Hashable 프로토콜
 
 
 hash함수
 - 어떠한 타입이 input -> 고정된 길이의 유일한 값으로 리턴
 - 타입이 유일한 값이 될 수 있으니 딕셔너리에서 key, set에서의 원소가 될 수 있다.
 */

let num1: Int = 123
let num2: Int = 456

// MARK: - 집합의 원소가 될 수 있다면 각 원소는 hashable하다
let set: Set = [num1, num2]

// 곧 사라질 구현
num1.hashValue


// MARK: - Hashable 프로토콜을 채택해서 연관값이 Hashable을 프로토콜을 채택한 타입들이라서 이미 값의 유일성이 보장되면
// 굳이 hash()메서드 구현하지 않아도 알아서 구현함
enum SuperComputer: Hashable {
    case cpu(core: Int, ghz: Double)
    case ram(Int)
    case hardDisk(gb: Int)
    
//    func hash(inti hasher: inout Hasher) {
//
//    }
}

let superSet: Set = [SuperComputer.cpu(core: 8, ghz: 3.5), SuperComputer.cpu(core: 16, ghz: 3.5)]


// 연관값이 없다면 hashable프로토콜 채택하지 않아도 유일성 판별 가능
enum Direction {
    case east  // 0
    case west  // 1
    case south // 2
    case north // 3
}

// 값
let directionSet: Set = [Direction.north, Direction.east]



// MARK: - 구조체인경우
struct Dog {
    var name: String
    var age: Int
}

// 구현하지 않아도 자동생성
// swift how to implement hash into
extension Dog: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(age)
    }
}

let dog1: Dog = Dog(name: "초코", age: 10)
let dog2: Dog = Dog(name: "보리", age: 2)

let dogSet: Set = [dog1, dog2]






// 예외-1) 클래스는 인스턴스의 유일성 갖게 하기위해서는 hash(into:)메서드 직접 구현해야함
//       (클래스는 원칙적으로 Hashable 지원 불가)



class Person {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}


// Set에 넣고 싶어서, Hashable 프로토콜 채택 ====> 클래스에서는 에러 발생 ===> hash(into:)메서드 직접구현해야함
// extension Person: Hashable {}


extension Person: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(age)
    }
    
    // == 연산자도 직접구현해야함
    // MARK: - Equatable프로토콜을 상속받고 있기 때문
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name && lhs.age == rhs.age
    }
}



let person1: Person = Person(name: "홍길동", age: 20)
let person2: Person = Person(name: "임꺽정", age: 20)

// MARK: - 클래스 인스턴스를 원소로 활용하려면 Hashable프로토콜을 채택해야한다-> 값의 유일성 보장을 위해
let personSet: Set = [person1, person2]

