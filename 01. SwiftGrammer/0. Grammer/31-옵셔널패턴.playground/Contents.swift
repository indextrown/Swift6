/*
 
 (58강) 옵셔널 패턴
 
 옵셔널 타입은 임시값으로 감싸고 있는 것
 
 */

let a: Int? = 1
print(a!)


// 열거형 케이스 패턴(앞에서 배운)
switch a {
case .some(let a):  // 내부 어떤 구체적인 연관값을 저장한거기 때문에 새로운 상수에 바인딩 가능
    print(a)
case .none:
    print("nil")
}

// 옵셔널 패턴 (현재 배움)
// 특이한 문법! 물음표를 붙히면 옵셔널
switch a {
case let z?:        // .some을 좀 더 간소화하는 문법 let z? = Optional.some(a)
    print(z)                               // let z = a
case nil:           // .none이라고 써도됨
    print("nil")
}


