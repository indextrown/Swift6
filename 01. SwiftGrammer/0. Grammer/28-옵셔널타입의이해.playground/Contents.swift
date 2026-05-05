/*
 
 
 (55강) 옵셔널 타입에 대한 정확한 이해
 
 옵셔널 타입
 - 메모리 공간에 임시적인 타입이 들어있는 개념
 
 임시적인 타입
 - Optional
 - nil
 
 
 옵셔널 타입
 - 내부적으로 case가 구현되어 있음
 - 임시적인 타입 = enum타입 => enum타입 case: .some, .none
  
 */


var num: Int? = 7


enum Optional2 {
    case some(Int)  // 정수가 연관값(구체적인 정보를 저장하는 값)으로 들어있음
    case none       //
}

var n1: Optional2 = Optional2.some(7)
var n2: Optional2 = Optional2.none

//if let n = n1 {
//    print(n)
//}

// 애플이 if let 바인딩으로 미리 구현해둠
// 복잡하게 벗겨야 되는것을 애플이 미리 구현 해둠
// .none와 nul은 완전히 동일하다
// nil: 값이 없음을 나타내는 키워드
// 벗기면 실제 값이 없어서 에러 발생함
// if let 바인딩으로 벗겨서 사용 하는 것은 실제로 케이스 안에 값을 꺼내서 사용하는 것이다
switch num {
case let .some(a):  //  == .some(let a)    let a = 7
    print(a)
case .none:
    print("nil")
}



