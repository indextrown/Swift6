import UIKit

/*

 중괄호는 클로저(함수)이다
 변수에 저장해서 변수를 실행할떄는 파라미터의 이름이 필요없다!!!!!
 
 */


// 함수의 타입 표기법
// 메모리공간만 만들고 실제로 함수를 만들고 할당한건아님
let functionA: (String) -> String

let functionB: (Int) -> ()

let functionC: (String) -> Void

// 기존의 함수의 형태와 클로저의 형태 비교
func aFunction(str: String) -> String {
    return "Hello \(str)"
}

// 클로저의 형태
// _ 와일드카드패턴
let _ = {(str: String) -> String in
    return "Hello \(str)"
}

// 1)
let aClosureType = { () -> () in
    print("안녕")
}

// 2) 타입: () -> () 즉 함수형 타입이다
// 함수를 변수에 담는다
let aClosureType2 = { print("안녕") }


// 함수 실행 가능
//aClosureType2()
//aClosureType2()
//aClosureType2()


func aFunction1(param: String) -> String {
    return param + "!"
}

func aFunction2(name: String) -> String {
    return name + "?!??"
}

// 함수를 변수에 할당가능(변수가 함수를 가르킨다)
// 변수에 저장해서 변수를 실행할떄는 파라미터의 이름이 필요없다!!!!!
var a: (String) -> String = aFunction1
a("안녕")
a("잡스")
a("조던")


a = aFunction2(name:)
a("안녕")



let closureType = { (param: String) -> String in
    return param + "!"
}


closureType("스티브")
