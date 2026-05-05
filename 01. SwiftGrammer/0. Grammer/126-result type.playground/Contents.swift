/*
 
 (186강)
 result type
 - swift 5에서 새로 도입된 개념
 - 타입 안에 결과를 넣어서 즉 결과를 가질 수 있는 타입
 
 */

/*
 
 MARK: 에러처리가 불편한 점이 있다. 정상적인경우랑 에러를 처리해야하는 경우 따로 나눠서 처리해야하고 do catch블럭을 통해 처리해야해서 불편하다
 MARK: 그래서 swift5에서 결과타입을 만들어서 타입 하나에 정상적인경우, 비정상적인경우 에러를 담을 수 있도록 만들었다
 
 
 retult type은 내부적으로 열거형으로 구현됨
 - 정상적/비정상적 경우 나눔
 - 연관값을 통해 구체적인 정보 전달도 가능하게 구현되어있음
 
 
 MARK: Result타입 사용하면 try보다 훨신 코드 깔끔해진다
 */

/**======================================================
 - 에러가 발생하는 경우, 에러를 따로 외부로 던지는 것이 아니라
 - 리턴 타입 자체를 Result Type(2가지를 다 담을 수 있는)으로 구현해서
 - 함수 실행의 성공과 실패의 정보를 함께 담아서 리턴


 - 실제 Result타입의 내부 구현
 - enum Result<Success, Failure> where Failure : Error 반드시 채택해야함
 - https://developer.apple.com/documentation/swift/result


 - Result타입은 열거형
 - case success(연관값)
 - case failure(연관값)
 ========================================================**/


import UIKit

// 에러 처리 과정(3단계)
enum HeightError: Error {
    case maxHeight
    case minHeight
}


func checkHeight(height: Int) throws -> Bool {
    if height > 100 {
        throw HeightError.maxHeight
    } else if height < 130 {
        throw HeightError.minHeight
    } else {
        if height >= 100 {
            return true
        } else {
            return false
        }
    }
}

do {
    let _ = try checkHeight(height: 200)
    print("놀이기구 타는 것 가능")
} catch {
    print("놀이기구 타는 것 불가능")
}


// MARK: result타입을 이용해 함수 새로 정의
// MARK: Result타입에는 성공/실패경우에 대한 정보가 다 들어있음
func resultTypeCheciHeight(height: Int) -> Result<Bool, HeightError> {
    if height > 190 {
        return Result.failure(HeightError.maxHeight)
    } else if height < 130 {
        return Result.failure(HeightError.minHeight)
    } else {
        if height >= 160 {
            return Result.success(true)
        } else {
            return Result.success(false)
        }
    }
}

// MARK: resultTypeCheciHeight()에 throws키워드가 없어서 try안붙혀도됨
let result = resultTypeCheciHeight(height: 160)

switch result {
case .success(let data):
    print("결과값은 \(data)입니다.")
case .failure(let error):
    print(error)
}



 
do {
    // MARK: .get()쓰면 다시 에러를 던지는 함수로 바뀐다
    let data = try result.get()
} catch {
    print(error)
}

/**==================================================
 - Result타입을 왜 사용할까?
 
 - 성공/실패의 경우를 깔끔하게 처리가 가능한 타입

 - 기존의 에러처리 패턴을 완전히 대체하려는 목적이 아니라
   개발자에게 에러 처리에 대한 다양한 처리 방법에 대한 옵션을 제공
 ====================================================**/
