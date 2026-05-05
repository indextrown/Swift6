/*
 
 (109강)
 생성자와 편의 생성자의 호출 규칙
 */


class Aclass {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {    // 지정생성자 - 모든 저장 속성 설정
        self.x = x
        self.y = y
    }
    
    convenience init() {     // 편의생성자 - (조금 편리하게 생성) 모든 저장 속성을 설정하지 않음
        self.init(x: 0, y: 0)
    }
}


// 상속이 일어나는 경우 ⭐️

class Bclass: Aclass {
    
    var z: Int
    
    init(x: Int, y: Int, z: Int) {    // 실제 메모리에 초기화 되는 시점
        self.z = z                 // ⭐️ (필수)
        //self.y = y               // 불가 (메모리 셋팅 전)
        super.init(x: x, y: y)     // ⭐️ (필수) 상위의 지정생성자 호출
        //self.z = 7
        //self.y = 7
        //self.doSomething()
    }

    
    convenience init(z: Int) {
        //self.z = 7     //==========> self에 접근불가
        self.init(x: 0, y: 0, z: z)
        //self.z = 7
    }
    
    convenience init() {
        self.init(z: 0)
    }
    
    func doSomething() {
        print("Do something")
    }
}


