/*
 
 (105강)
 
 재정의
 
 속성의 재정의
 - 타입/인스턴스 속성을 구분해서 생각해야 하지만, 실질적으로 타입 속성을 재정의를 하지는 않음.
 
 (1) 저장 속성의 재정의
 - 원칙적으로 불가능(고유한 메모리 공간은 유지 해야함)
 ==>저장속성은 고유의 메모리 공간이 있어서 하위클래스에서 고유의 공간을 바꾸는 방식으로 재정의 불가능
 ==>메모리 공간을 바꾸지 않는 방식으로는 재정의 가능
 
 (메서드 형태로 추가하는 방식의 재정의 가능)
 ==>메모리 구조를 건들지 않아서 가능
 ==>읽기/쓰기가능한 계산속성으로 재정의 가능(메서드), 기능 축소는 불가능x
 ==>속성 감시자를 추가는 가능(메서드) (실질적 단순 메서드를 추가해서 저장 속성이 변하는 시점을 관찰할뿐임)
 
 계산속성
 - 실질적인 메서드, 기능의 범위를 축소하는 형태로의 재정의는 불가능
 - 상위에서 읽기/쓰기가능하도록하면 하위에서도 읽기/쓰기가능하도록
 - 기능 확장은 가능하지만 기능 축소는 불가능
 - 속성 감시자를 추가하는 재정의는 불가능(어차피 읽기 전용이라서)!!!!!!!!!!!!
 
 - 상위에서 읽기/쓰기가능한 계산속성이있으면 하위에서 읽기만 가능한 속성으로만 재정의 불가능(기능제한x)
 - 속성 감시자를 추가하는 재정의는 가능(관찰은 가능)
 
 정리
 - 저장속성의 재정의는 원칙적 불가능(상위 속성의 고유 메모리 공간을 변형 불가)
 - 메서드 방식으로 추가는 가능하다
 - 계산속성의 유지/확장은 가능, 축소는 불가능
 - 속성 감시자(메서드)를 추가하는 재정의는 언제나 가능(단순 메서드 추가)
 - 다만 읽기전용 계산 속성을 관찰하는것은 의미 없어서 불가능하다
 
 
 (실질적으로 안씀)
 타입 속성의 재정의 원칙
 - 타입 저장 속성은 재정의 불가 - static키워드(계산속성으로 정의하거나 속성 감시자를 추가하는 것도 불가능)
 - 타입 계산 속성(실질적으로 타입 메서드) - class키워드인경우 재정의 (확장방식) 기능
 -> static키워드: 재정의 불가 class키워드: 재정의 가능
 - 재정의 타입 저징/계산 속성에는 감시자 추가 원칙적으로 불가
 
 메서드 재정의
 - 속성에 비해 메서드 재정의 자유로움
 - 생성자 재정의 따로 생각해봄
 - 상위 클래스에서 인스턴스 메서드, 타입 메서드 상관없이 기능 추가하는 것도 가능하다
 - 상위 기능을 무시하고 새롭게 구현 하는 것도 가능(제약없음- 메서드 이름만 동일하고 완전히 새롭게 구현 가능하다고 생각하면됨)
 - 다만 기능을 추가하는 구현을 선택할 시 상위구현의 기능을 먼저 실행할지의 여부는 개발자의 선택
 
 
 */

// 재정의 기본 문법
class SomeSuperclass {
    // 저장속성
    var aValue = 0
    
    // 메서드
    func doSomething() {
        print("Do something")
    }
}


class SomeSubclass: SomeSuperclass {
    // 저장속성의 재정의는 원칙적 불가
    //override var aValue = 3
    
    // 그러나 메서드 형태로 부수적 추가는 가능
    // 메서드 형태로 새롭게 구현하는 것은 상위에 있는 메모리르 건들지 않는다
    override var aValue: Int {
        get {
            return 1
        }
        set {   // self로 쓰면 안됨
            super.aValue = newValue
        }
    }
    
    override func doSomething() {
        super.doSomething()
        print("Do something 2")
    }
}



// 속성의 재정의(엄격)

class Vehicle {
    // 저장속성
    var currentSpeed = 0.0
    
    // 계산속성(실질적인 메서드2개)
    var halfSpeed: Double {
        get {
            return currentSpeed / 2
        }
        set {
            currentSpeed = newValue * 2
        }
    }
}

class Bicycle: Vehicle {
    // 저장 속성 추가는 당연히 가능
    var hasBasket = false
    
    
    
    // 1) 저장속성 ==> 계산속성으로 재정의(메서드 추가) 가능
//    override var currentSpeed: Double {
//        get {
//            return super.currentSpeed / 2
//        }
//        set {
//            super.currentSpeed = newValue
//        }
//    }
    
    // 2) 속성감시자
    override var currentSpeed: Double {
        willSet {
            print("값이 \(currentSpeed)에서 \(newValue)로 변경 예정")
        }
        didSet {
            print("값이 \(oldValue)에서 \(currentSpeed)로 변경 예정")
        }
    }
    
    // 3) 계산속성 재정의 가능 super키워드 필수
//    override var halfSpeed: Double {
//        get {
//            return super.currentSpeed / 2
//        }
//        set {
//            super.currentSpeed = newValue * 2
//        }
//    }
    
    // 4) 상위에 있는 계산속성을 재정의하면서 속성감시자 추가
    // 계산속성에는 속성감시자 추가 불가능하다
    // 어차피 set블럭에서 속성감시자 기능 추가 가능하기 때문
    // 하지만 예외적으로 상속을 해서 재정의하는경우 추가 가능!!!!!!!!!!!
    override var halfSpeed: Double {
        willSet {
            print("값이 \(halfSpeed)에서 \(newValue)로 변경 예정")
        }
        didSet {
            print("값이 \(oldValue)에서 \(halfSpeed)로 변경 예정")
        }
    }
}



class Vehicle1 {
    // 저장속성
    var currentSpeed = 0.0
    var datas = ["1", "2", "3", "4", "5"]
    
    // 메서드
    func makeNoise() {
        print("경적을 울린다")
    }
     
    // 서브스크립트(메서드)
    subscript(index: Int) -> String {
        get {
            if index > 4 {
                return "0"
            }
            return datas[index]
        }
        set {
            datas[index] = newValue
        }
    }
}


class Bicycle1: Vehicle1 {
    // 1) 상위 => 하위 호출 (가능)
    override func makeNoise() {
        super.makeNoise() // 상위 구현 먼저 호출
        print("자정거가 지나간다고 소리친다.")
        super.makeNoise() // 상위 구현 나중에 호출
    }
    
    // 2) 서브스크립트 재정의가능 ==> 메서드이기떄문
    override subscript(index: Int) -> String {
        get {
            if index > 4 {
                return "777"
            }
//            return super.datas[index]
            return super[index] // 상위 서브스크립트 호출로 생각하면됨
        }
        set {
//          super.datas[index] = newValue
            super[index] = newValue // 상위 서브스크립트 호출로 생각하면됨
        }
    }
}
