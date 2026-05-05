import UIKit
/*
 
 (149강)
 @escaping
 - 원칙적으로 함수의 실행이 종료되면 쓰이는 클로저도 제거됨
 - @escaping 키워드는 클로저를 제거하지 않고 함수에서 탈출시킴(함수가 종료되어도 클로저가 존재하도록 함)
 ==> 클로저가 함수의 실행흐름(스택프레임)을 벗어날 수 있도록 함
 
 함수를 변수에 저장한다 = 함수를 오래동안 사용하겠다
 -> 그럴때 heap 메모리에 저장한다 = 클로저 방식으로 저장한다
 
 @autoclosure키워드
 - 자동으로 클로저를 만들어준다
 - 파라미터가 없는 클로저만 사용가능하다
 - 중괄호가 번거러울경우, 파라미터가 없는 경우에만 사용가능하다
 - 번거로움을 해결해주지만, 실제 코드가 명확해 보이지 않을 수 있으므로 사용 지양(애플 공식 문서)
 - 우리가 배우는 이유: 가끔씩 애플에서 만든 함수가 autoclosure를 사용하는데 이를 잘 사용하기 위해서
 - 사용목적x,  읽기 위한 목적으로 공부
 - 기본적으로 non-escaping
 
 */


// 1) 클로저를 단순 실행(non-escaping)
func performEscaping1(closure: () -> ()) {
    print("프린트 시작")
    closure()
}

performEscaping1 {
    print("프린트 중간")
    print("프린트 종료")
}

// 2) 클로저를 외부변수에 저장(escaping)
/*
 1) 함수 내부에서 사용할 클로저를 외부 변수에 저장 --> @escaping은 함수를 탈출시킨다
 2) GCD (비동기 코드의 사용)
 
 */

// 함수타입
var aSavedFunction: () -> () = { print("출력") }
aSavedFunction()

// 외부에 있는 aSavedFunction에 할당하고 있다
func performEscaping2(closure: @escaping () -> ()) {
    aSavedFunction = closure
}

// 1) 2) 둘다 실행안됨. 단순히 aSavedFunction에 할당만 한다

// 1)
performEscaping2(closure: { print("다르게 출력1") })
aSavedFunction()

// 2)
// 트레일링 클로저 방식(선호)
// 이 함수는 다르게 출력이라는 클로저를 aSavedFunction에 할당하는 역할이다
performEscaping2 {
    // 클로저
    print("다르게 출력2")
}
aSavedFunction()



func performEscaping1(closure: @escaping (String) -> ()) {
    
    var name = "홍길동"
    // 1초뒤에 실행한다
    // 원래 정의된 함수의 스택프레임의 실행흐름을 벗어나겠다
    // 1초라도 더 오래동안 저장하고 사용한다는 의미
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {   //1초뒤에 실행하도록 만들기
        closure(name)
    }
    
}

performEscaping1 { str in
     print("이름 출력하기: \(str)")
}





// @autoclosure키워드
// 자동으로 클로저를 만들어준다
// 파라미터를 함수라고 지정했는데 참과 거짓을 달라고 한다
func someFunction(closure: @autoclosure () -> Bool) {
    if closure() {  // true or false
        print("참입니다.")
    } else {
        print("거짓입니다.")
    }
}

var num = 1

// 파라미터를 함수라고 지정했는데 참과 거짓을 달라고 한다
someFunction(closure: true)

// 참과 거짓을 판단할 수 있는 문장만 주면 알아서 {}를 붙혀서 자동으로클로저를 만들어준다
// 컴파일러 동작: someFunction(closure: {true})
someFunction(closure: num == 1)


func someAutoClosure(closure: @autoclosure @escaping () -> String) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {   //1초뒤에 실행하도록 만들기
        print("소개합니다: \(closure())")
    }
}

someAutoClosure(closure: "제니")
