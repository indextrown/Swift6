/*
 
 (111-1강)
 
 (지정)생성자
 - 나의 단계에 있는 저장속성의 값(= 메모리값)을 세팅하는 역할
 - 내가 할 수 없는 것은 상위에 위임
 - super.init()
 
 편의 생성자
 - 상위로 위임이 아니라 나의 단계로 위임히는것 self.init()
 
 재정의(override)
 - 똑같은 이름이 생성자를 또 구현하는것
 

 저장속성을 옵셔널로 설정하면?
 - 자동으로 nil초기화됨
 - 데이터 값이 없어도됨
 
 */


class Aclass {
    var x: Int
    var y: Int
    
    // 지정생성자 == 무조건 저장속성 값을 세팅해야함
    // 나의 단계의 저장속성 메모리값을 제대로 세팅해야 실제로 heap공간에 인스턴스 찍어낼 수 있음
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    // 편의생성자 = 편리하게 생성할 수 있는 생성자
    // 직접적으로 메모리 값 세팅못하고 지정생성자를 호출해서 메모리 값을 호출한다
    convenience init() {
        self.init(x: 0, y: 0)
    }
    
    convenience init(x: Int) {
        self.init(x: x, y: 0)
    }
}


class Bclass: Aclass {
    // 저장속성을 하나 더 선언했다==인스턴스를 찍어내면 결과적으로 데이터필드 하나 더 추가된 3개를 가져야 한다
    // 상속을 해서 상위에서 정의한 x, y도 가지고 z가 추가된다는 의미다
    var z: Int
    
    // 지정생성자
    init(x: Int, y: Int, z: Int) {
        // swift에서는 자기단계를 먼저 설정해야함 <---> java와 반대개념
        // java는 차례대로 메모리 공간을 생성 swift는 반대로 아래서부터 공간을 만듬
        self.z = z
        
        // self.x = x  내가 할 수 있는 일이 아니라 위쪽으로 위임해야함
        // swift에서는 z라는 공간을 만들고 x, y를 찍어낸다
        super.init(x: x, y: y)
    }
    
    // 지정생성자로 재정의 ==> 상위 지정생성자와 같은 이름으로
//    override init(x: Int, y: Int) {
//        self.z = 0
//        super.init(x: x, y: y)
//    }
    
    // 편의생성자로 재정의 ==> 편의생성자는 편리하게 하기위함 즉 나의단계에서 호출
    override convenience init(x: Int, y: Int) {
        self.init(x: x, y: y, z: 0)
    }
}
