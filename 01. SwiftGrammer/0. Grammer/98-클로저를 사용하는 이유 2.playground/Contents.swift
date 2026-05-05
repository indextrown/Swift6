import UIKit


/*
 
 클로저
 미리 어떤 함수를 정의하고 사용하는것보다
 클로저를 정의를 하면서 전달을 한다는 것이 개발자가 만들고 싶은 함수를 정의할 수 있어서 활용도가 엄청 커진다
 
 
 클로저 사용하는 이유
 - 미리 애플이 정의해 놓은것을 잘 사용하기 위해
 - 사후적으로 클로저를 정의하면서 전달하기 위해
 
 */

// 1) 클로저를 파라미터로 받는 함수 정의
func closureCaseFunction(a: Int, b: Int, closure: (Int) -> Void) {
    let c = a + b
    closure(c)
}
                                        // param에 10을 받는거다
closureCaseFunction(a: 7, b: 3, closure: { param -> () in
    print("안녕하세요 \(param)")
})

closureCaseFunction(a: 5, b: 2, closure: { n in     // 사후적 정의
    print("출력")
    print("출력")
    print("출력")
    print("값: \(n)")
})



//
closureCaseFunction(a: 7, b: 3, closure: { number in
    // 사후적 정의
    print(number)
    print(number)
    print(number)
})

// 트레일러 클로저
closureCaseFunction(a: 7, b: 3) { number in
    // 사후적 정의
    print(number)
    print(number)
    print(number)
}

let print1 = {
    print("1")
}

let print2 = {
    print("2")
}

let print3 = {
    print("3")
}

// 함수의 정의
func multiClosureFunction(closure1: () -> Void, closure2: () -> Void) {
    closure1()
    closure2()
}

multiClosureFunction(closure1: print1, closure2: print2)

multiClosureFunction(closure1: {
    print("777")
    print("777")
}, closure2: {
    print("888")
    print("888")
})


func performClosure(closure: () -> ()) {
    print("시작")
    closure()
    print("끝")
}

// 클로저가 길떄 유용하다
// 마지막 인자가 클로저일떄 함수 호출 시 소괄호 () 외부에 클로저를 작성할 수 있다
performClosure {
    print("중간")
}

performClosure(closure: {
    print("중간")
})
