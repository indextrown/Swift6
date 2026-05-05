/*
 
 (112강)
 
 
 필수생성자
 - 필수 생성자-> 하위클래스에서도 반드시 필수생성자 구현해야함
 - 하위에서 재정의 키워드를 사용할 필요 X
 - 예외적으로 필수생성자 구현안해도되는경우
 - 다른 지정 생성자 구현 안하면 자동 상속된다
 
 필수생성자 필요한 이유
 - 우리가 구현할 때 필수생성자 잘 안쓰긴 함
 - 애플이 만들어 놓은 필수생성자가 있는 경우가 꽤 많다
 - 그래픽관련, 내부적인 메커니즘이 세밀하게 구현되있는데 이때 필수생성자가 필요함
 
 */

class Aclass {
    var x: Int
    
    // 필수 생성자-> 하위클래스에서도 반드시 필수생성자 구현해야함
    // 하위에서 재정의 키워드를 사용할 필요 X
    required init(x: Int) {
        self.x = x
    }
}


class Bclass: Aclass {
//    required init(x: Int) {
//        super.init(x: x)
//    }
//  실제로 구현안해도 swift에서 자동으로 제공해준다

    
    // 예외적으로 필수생성자 구현안해도되는경우
    // 다른 지정 생성자 구현 안하면 자동 상속된다
}


class Cclass: Aclass {
    
    // 다른 지정생성자 구현해서 자동상속 조건을 벗어나서 필수생성자 구현해야함
    init() {
        super.init(x: 0)
    }
    
    // 직접 구현해야함
    required init(x: Int) {
        super.init(x: 0)
    }
}



// 필수생성자 사용예시 UIView(네모상자)
//class AView: UIView {
//    // 다른 지정생성자 구현 안했기 때문에 자동상속이 되는 경우다
//    //    required init?(coder: NSCoder) {         // 구현을 안해도 자동상속
//    //        fatalError("init(coder:) has not been implemented")
//    //    }
//    
//    // 만약 생성자 구현하면 필수생성자 구현헤라고 에러뜸
//    init() {
//        
//    }
//    
//    // 직접 구현해야함
////    required init?(coder: NSCoder) {         // 구현을 안해도 자동상속
////        fatalError("init(coder:) has not been implemented")
////    }
//}



//class BView: UIView {
//    // 지정생성자 구현했음으로 필수생성자 자동상속 안됨 -> 직접 구현해야함
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    // 필수 생성자 직접 구현
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//
//


