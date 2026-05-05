import UIKit

/*
 
 클로저를 사용하는 이유
 - 함수를 실행시 파라미터로 클로저를 정의를 하면서 전달을 하는 형태로 많이 쓰이기 때문에 사용한다
 
 클로저 이름이 필요없는 이유
 - 다른 함수를 실행할 때 전달하는 형태로 클로저를 사용하기 때문에 이름이 필요x
 
 콜백함수
 - 함수를 실행할 때 파라미터로 전달하는 함수를 의미함
 
 
 
 */

// 1) 클로저를 파라미터로 받는 함수를 정의
func closureParamFunction(closure: () -> ()) {
    print("start")
    closure()
}

// 함수
func printSwiftFunction() {
    print("프린트 종료")
}

let printSwift = { () -> () in
    print("프린트 종료")
}

// 1) 함수 실행시 파라미터를 클로저 형태로 전달
closureParamFunction(closure: {print("프린트 종료")})

// 2) 함수를 입력으로
closureParamFunction(closure: printSwiftFunction)

// 3) 클로저를 입력으로
closureParamFunction(closure: printSwift)

// 4) 파라미터로 함수 여러개 가능
closureParamFunction(closure: {
    print("프린트 종료 - 1") // call back 함수
    print("프린트 종료 - 2") // call back 함수
})
