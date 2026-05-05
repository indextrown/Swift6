/*
 
 (100강)
 
 실습자료
 - 11-2-5
 
 메서드
 - 클래스나 구조체 내에 있는 함수
 
 인스턴스메서드
 - 다른 메서드 호출 가능
 
 구조체 속성 변경시
 - mutating 사용
 
 차이점
 - 구조체는 원칙적으로 자기자신의 속성을 바꿀 수 없어서 바꾸려면 메서드에 mutating 붙혀줘야함
 - 클래스의 인스턴스메서드에서는 자기자신의 속성을 바꿀 수 있다
 - 클래스는 데이터를 heap 영역에 저장
 - 구조체는 데이터를 stack 영역에 저장해서 메서드로 바꿀 수 없다 -> mutating 필요
 - 값타입의 인스턴스 메서드 내에서 자신의 속성값 수정은 원칙적 붉 -> mutating 필요
 
 오버로딩
 - 하나의 함수 이름에 여러가지 이름 붙힐 수 있음
 
 
 메서드(함수)
 - cpu에 대한 명령어의 붂음
 - 코드 영역에만 존재하기 때문에 코드 영역에 메서드가 존재하는 메모리 주소만 알고 있으면 됨
 - 즉 메모리 공간이 할당되어 있지 않음
 
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
}

let bori = Dog(name: "보리", weight: 20.0)
//bori.name
//bori.sit()
//bori.layDown()
//bori.play()
//bori.changeName(newName: "보리")
//bori.name

//bori.training()
//bori.changeName(newName: "초코")
//bori.training()


// 오버라이딩
bori.sit(a: "hello")





// 구조체


struct Dog2 {
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
    
    // error: self는 변할 수 없다
    // 구조체나 열거형은 기본적으로 인스턴스 내에서 속성을 수정할 수 없음
    mutating func changeName(newName name: String) {
        self.name = name
    }
    
    func training() {
        print("저는 \(name) 입니다")
        sit()
        sit()
        self.sit()  // self키워드는 명확하게 지칭하는 역할일 뿐
        print()
    }
}

var choco = Dog2(name: "초코", weight: 1.5)

// 둘다 같은 의미
// choco.name = "choco"
choco.changeName(newName: "choco")
