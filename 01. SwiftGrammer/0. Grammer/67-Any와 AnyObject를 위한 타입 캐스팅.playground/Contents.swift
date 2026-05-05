/*
 
 (118강)
 
 1) Any타입
 - 장점: 모든 타입을 담을 수 있는 배열을 생성 가능하다
 - 단점: 저장된 타입의 메모리 구조를 알 수 없기 때문에 항상 타입캐스팅해서 사용해야한다(불편하다)
        -> 일반적으로 사용하지는 않는다
 
 ! 다운캐스팅
 ? 옵셔널 값이 나올수도 있음
 클로저는 또다른 함수 형태
 
 2) AnyObject타입
 - 클래스의 인스턴스만 담을 수 있는 타입
 
 
 */



var some: Any = "swift"
some = 10
some = 3.2
some = "12345"
// some.count  // 불가능
// print(some)
// some라는 변수를 string타입으로 타입캐스팅후 some1에 담고 카운트한다
var some1 = (some as! String)
// print(some1.count)
(some as! String).count

some = 10
(some as! Int).hashValue



class Person {
    var name = "이름"
    var age = 10
}

class Superman {
    var name = "이름"
    var weight = 100
}


// Any타입 장점: 모든 타입을 담을 수 있는 배열을 생성 가능하다               (String) -> String
let array: [Any] = [5, "안녕", 3.5, Person(), Superman(), {(name: String) in return name}]

for i in array {
    print(i)
}

(array[1] as! String).count



// AnyObject타입
let objArray: [Any] = [Person(), Superman()]
(objArray[0] as! Person).name


for (index, item) in array.enumerated() {
    // as는 타입캐스팅 즉 num에 담겠다 즉 바인딩하겠다
    // as일때는 바인딩을 해서 새로운 상수에 담는다
    // is일때는 바인딩 안한다
    switch item {
    case is Int:                // item is Int
        print("Index - \(index): 정수입니다.")
    case let num as Double:     // let num = item as Double
        print("Index - \(index): 소수입니다.")
    case is String:             // item is String
        print("Index - \(index): 문자열입니다.")
    case let person as Person:  // let person = item as Person
        print("Index - \(index): 사람입니다.")
        print("아름은 \(person.name)입니다.")
        print("아름은 \(person.age)입니다.")
    case is (String) -> String: // item is (String) -> String
        print("Index - \(index): 클로저 타입입니다.")
    default:
        print("Index - \(index): 그 이외의 타입입니다.")
    }
}

// 옵셔널값의 Any 변환
let optionalNumber: Int? = 3
print(optionalNumber)           // 경고창 발생

// 경고창 없어짐 이유: Any는 모든 타입을 포함해서 의도적인 옵셔널 값을 사용시 Any타입으로 변환해주면 컴파일러가 알려주는 경고를 없앨 수 있다
// (optionalNumber as Any)자체가 하나의 타입이 된다
print(optionalNumber as Any)

print(optionalNumber as! Int)
