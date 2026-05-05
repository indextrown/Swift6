/*
 
 (157강)
 /**==========================================
  - 객체가 서로를 참조하는 강한 참조 사이클로 인해
  - 변수의 참조에 nil을 할당해도 메모리 해제가 되지 않는
  - 메모리 누수(Memory Leak)의 상황이 발생
 =============================================**/

 
 
 비소유 참조의 경우, 참조하고 있던 인스턴스가 사라지면, nil로 초기화 되지 않음
 
 nil은 실제 값이 없는게 아니라 값이 없음을 나타내는 키워드이다
 옵셔널 타입은 열거형에서 sum과 none라는 케이스를 가지고 있다
 nil은 열거형의 하나의 케이스일뿐이다
 
 정리
 - nil이 있다는거는 열거형이 있다는거 -> 에러안남
 - 비소유 차조일경우 nil로 초기화 안된다, 실제로 메모리 주소에 값이 없다 -> 에러발생
 
 */

class Dog {
    var name: String
    // var owner: Person?
    // weak var owner: Person?  // 약산 참조
    unowned var owner: Person?  // 비소유 참조
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) 메모리 해제")
    }
}

class Person {
    var name: String
    // var pet: Dog?
    // weak var pet: Dog?       // 약산 참조
    unowned var pet: Dog?       // 비소유 참조
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) 메모리 해제")
    }
}

var bori: Dog? = Dog(name: "보리")
var gildong: Person? = Person(name: "홍길동")


bori?.owner = gildong
gildong?.pet = bori

// 1) 이 주석을 해제해야 메모리 해제됨
//bori?.owner = nil
//gildong?.pet = nil


// 메모리 해제가 안됨
// 강한 참조 사이클(Strong Reference Cycle)이 일어남
//bori = nil
//gildong = nil



// 1)을 통해 해결방법은 번거롭다
/*
 해결법
 - 1) weak reference(약한참조)
 - 2) Unknowed Reference(비소유참조)
 
 */

// 약한 참조의 경우 참조하고 있던 인스턴스가 사라지면 nil로 초기화 되어있음
gildong = nil
bori?.owner


