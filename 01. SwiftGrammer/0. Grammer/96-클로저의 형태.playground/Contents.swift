import UIKit

func add(a: Int, b: Int) -> Int {
    let result = a + b
    return result
}

let _ = {(a: Int, b: Int) -> Int in
    let result = a + b
    return result
}

let _: (Int, Int) -> Int =
{(a, b) in
    let result = a + b
    return result
}



// 클로저 형태
// 리턴타입 생략
let aClosure1 = { (str: String) in
    return "Hello, \(str)"
}

// 아규먼트 레이블 타입 생략
let aClosure2: (String) -> String = { (str) in
    return "Hello \(str)"
}

// () -> () 생략되있음 // inp, oup없음
let closure3 = {
    print("This is a closure")
}

// 컴파일러가 타입 추론 가능한 겨우 생략 가능
// 컴파일러에서 param이 문자열임을 추론 가능
let closureType4 = { param in
    return param + "!"
}


