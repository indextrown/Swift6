import UIKit


/*
 
 클로저는 실제 사용시 읽기 쉽고, 간결한 코드 작성을 위해 축앙된 형태의 문법을 제공함
 사후적으로 정의할 수 있어서 클로저를 사용한다
 

 /**=============================================================================
  [문법 최적화(간소화)]
  - 1) 문맥상에서 파라미터와 리턴밸류 타입 추론(Type Inference)
  - 2) 싱글 익스프레션인 경우(한줄), 리턴을 안 적어도 됨(Implicit Return)
  - 3) 아규먼트 이름을 축약(Shorthand Argements) ===> $0, $1
  - 4) 트레일링 클로저(후행 클로저) 문법: 함수의 마지막 전달 인자(아규먼트)로 클로저 전달되는 경우, 소괄호를 생략 가능
  ===============================================================================**/
 
 */


// (클로저를 파라미터로 받는) 함수 정의
func closureCaseFunction(a: Int, b: Int, closure: (Int) -> Void) {
    let c = a + b
    closure(c)
}

closureCaseFunction(a: 5, b: 2) { (number) -> Void in
    print("출력할까요? \(number)")
}

// output 생략가능
closureCaseFunction(a: 5, b: 2) { (number) in
    print("출력할까요? \(number)")
}


// (클로저를 파라미터로 받는) 함수 정의
func closureParamFunction(closure: () -> Void) {
    print("프린트 시작")
    closure()
}

// 1, 2, 3, 4 같음

// 1)
closureParamFunction(closure: {
    print("프린트 종료")     // 사후적으로 정의할 수 있어서 클로저를 사용한다
})

// 2)
closureParamFunction(closure: ) {
    print("프린트 종료")
}

// 3)
closureParamFunction() {
    print("프린트 종료")
}

// 4) 후행 클로저 문법
// 함수를 실행하면서 클로저를 input으로 사용하고 있구나를 인지해야함
closureParamFunction {
    print("프린트 종료")
}



// 마지막 파라미터에서 중괄호를 누르면 줄이는게 아님
// 마지막 파라미터에서 마우스 커서를 두고 엔터를 하면 자동으로 후행클로저 문법에 맞게 수정함
closureCaseFunction(a: 3, b: 3) { n in
    print("단순출력")
}




print("###########")

// 함수 정의
func performClosure(param: (String) -> Int) {
    param("Swift")
}

// 1) 타입 추론
performClosure(param: { (str: String) -> Int in
    return str.count
})

// 2) output 추론
performClosure(param: { (str: String) in
    return str.count
})

// 3) 매개변수 타입 추론
performClosure(param: { str in
    return str.count
})

// 4) 클로저가 한줄이면 return 생략가능
performClosure(param: { str in
    str.count
})

// 5) 파라미터 생략 가능 첫번쨰 파라미터: $0
performClosure(param: {
    $0.count
})

// 6) 트레일링 클로저
// 첫번쨰 파라미터르 카운트 하고있구나
// 이게 제일 중요함!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
performClosure { $0.count }






// 동일한 코드1
let closureType1 = { param in
    return param % 2 == 0
}

// 동일한 코드2
let closureType2 = { $0 % 2 == 0 }

// 동일한 코드3
let closureType3 = { (a: Int, b: Int) -> Int in
    return a * b
}

// 동일한 코드4
let closureType4: (Int, Int) -> Int = { (a, b) -> Int in
    return a * b
}

// 곱하기를 할때 Double타입끼리 곱할 수도 있어서 타입을 명시해줘야함
let closureType5: (Int, Int) -> Int = { $0 * $1 }

