/*
 (101강)
 
 타입 메서드
 - 붕어빵틀 자체에 속한 메서드
 - 예시 Int.random(in: 1...100)
 
 static. class
 - static랑 class 동일한 의미
 - 차이점: static는 재정의 불가 class는 가능
 */



class Dog {
    // 타입 저장속성
    static var species = "Dog"
    var name: String
    var weight: Double
    
    init(name: String, weight: Double) {
        self.name = name
        self.weight = weight
    }
    
    // 인스턴스메서드(가장 기본적인 메서드)
    func sit() {
        print("\(name)가 앉았습니다")
    }
    
    func layDown() {
        print("\(name)가 누웠습니다")
    }
    
    func play() {
        print("열심히 놉니다")
    }
    
    // 저장속성의 저장된 정보를 바꿔주는 메서드
    func changeName(newName name: String) {
        self.name = name
    }
    
    func training() {
        print("저는 \(name) 입니다")
        sit()
        sit()
        self.sit()  // self키워드는 명확하게 지칭하는 역할일 뿐
        print()
    }
    
    // 오버라이딩
    func sit(a: String) {
        print("\(a)")
    }
    
    // 타입 메서드: 타입 저장속성에 접근 가능
    static func letMeKnow() {
        // 일반적으로는 Dog.species 써야하지만 타입 메서드를 통해 species로 접근 가능
        print("좋은 항상 \(species) 입니다.")  // Dog.species 라고 써도됨
    }
    
    // static랑 class 동일한 의미
    // 차이점: static는 재정의 불가 class는 가능
    class func letMeKnow2() {
        // 일반적으로는 Dog.species 써야하지만 타입 메서드를 통해 species로 접근 가능
        print("좋은 항상 \(species) 입니다.")  // Dog.species 라고 써도됨
    }
    
    
}


let bori  = Dog(name: "보리", weight: 1.5)
Dog.letMeKnow()



// 상속클래스
// 상위클래스
class SomeClass {
    class func someTypeMethod() { // 타입 메서드
        print("타입과 관련된 공통의 기능의 구현")
    }
}
SomeClass.someTypeMethod()

// 재정의
// 상속한 서브클래스
class SomeThingClass: SomeClass {
    override class func someTypeMethod() {
        print("타입과 관련된 공통의 기능의 구현(업그레이드)")
    }
}
SomeThingClass.someTypeMethod()

