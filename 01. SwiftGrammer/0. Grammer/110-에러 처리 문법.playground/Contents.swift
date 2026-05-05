import UIKit

/*
 
 에러의 종류
 1) 컴파일 오류
 -> 코드를 잘못 친 문법적 오류
 -> 바로 알려줘서 수정 가능
 2) 런타임 오류
 -> 여러가지 다양한 이유로 앱이 꺼질 수 있는 상황이 발생한다
 -> 미리 발생가능한 에러를 파악해두면 사전에 예외적인 처리를 할 수 있다
 
 함수를 정의해서 사용했는데 함수 자체를 에러가 발생할 수 있는 함수다 라고 정의할 수 있다
 -> 즉 정상적인 경우에는 제대로 나오는데
 -> 이상한 상황이 발생하면 함수의 아웃풋이 나오는게 아니라 함수를 옆으로 빠져나온다 == 문법적으로 에러를 던진다 throw라고 표현한다
 
 정리
 - 런타임 에러 --> 크래시(앱이 강제 종료)
 ---> 발생가능한 에러를 미리 처리해 두면, 강제종료되지 않음(개발자가 처리해야만 하는 에러)
 
 
 
 에러는 열거형이다
 - 함수를 정의하기 전에 에러를 먼저 정의해야한다
 - 열거형은 프로토콜을 채택해야한다(Error)
 
 Error 프로토콜을 채택하는이유
 - swift에서 사용하는 에러 기능을 애플이 구현해둠
 
 에러 처리과정(3단계)
 - 에러를 먼저 정의
 - 에러가 발생할 수 있는 함수 정의
 - 에러가 발생할 수 있는 함수에 대한 처리
 
 정상적인 상황의 결과값이 나왔을떄 do 블록 안에서 처리한다
 catch는 함수가 에러를 던졌을 때
 
 do블럭: 함수를 통한 정상적인 처리의 경우 실행하는 블럭
 catch블럭: 함수가 에러를 던졌을 경우의 처리 실행하는 블럭
 
 */

// 열거형의 case는 소문자로 시작해야한다

// 1) 에러 정의(어떤 에러가 발생할지 경우를 미리 정의)
enum SomeError: Error {
    case aError
    case bError
    case cError
}

// 2) 에러가 발생할 수 있는 함수 정의
func doSomething(_ num: Int) throws -> Bool {
    if num >= 7 {
        return true
    } else {
        // 비정상적인 경우 에러를 던지겠다
        if num < 0 {
            throw SomeError.aError
        }
        return false
    }
    
}

// 3)함수 실행

// 1) try
// 모든 에러발생의 예외적인 경우를 디테일하게 처리 가능
do {
    let data = try doSomething(7)
} catch {
    print("에러 처리")
}

// 2) try? (Optional try)
let data = try? doSomething(7)


// 3) try! (Forced try)
// 에러가 발생할 가능성이 없는 경우 제한적으로 사용
let data2 = try! doSomething(7)
//let data3 = try! doSomething(-7) // 런타임 에러

//
enum HeightError: Error {
    case maxHeight
    case minHeight
}

func checkingHeight(height: Int) throws -> Bool {
    if height > 190 {
        throw HeightError.maxHeight
    } 
    else if height < 130 {
        throw HeightError.minHeight
    } 
    else {
        if height >= 160 {return true}
        else {return false}
    }
}



// 에러가 발생할 수 있는 함수의 처리(함수의 실행) ==> try를 붙혀줘야함
do { // 정상적인 경우의 처리 상황
    var result = try checkingHeight(height: 160)
    print("결과값: \(result)")
    
    if result {
        print("참")
    } else {
        print("거짓")
    }
    
} catch { // 비정상적인 경우의 처리 상황
    print("에러가 발생한 경우의 처리")
}



// 에러 발생가능한 함수의 형태
/*
 input도 void고 output도 void인데 에러를 발생시킬 수 있는 함수 타입이구나 라고 생각 가능해야함
() throws -> ()
 */



// 정수를 받아서 어떠한 타입으로도 변형할 수 있는데 에러를 던질 수 있는 함수 타입구나
// [1, 2, 3, 4, 5].map(<#T##transform: (Int) throws -> T##(Int) throws -> T#>)
