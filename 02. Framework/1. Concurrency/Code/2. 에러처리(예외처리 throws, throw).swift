//
//  2. 에러처리(예외처리).swift
//  Swift5
//
//  Created by 김동현 on 2/4/25.
//

/*
 에러 핸들링(swift 공식 문서), exception 핸들링(프로그래밍 용어)이라고 지칭
 
 에러 처리 문법의 필요성
 - 앱이 꺼질 수 있는 상황을 미리 파악해서 에러처리를 해놓으면
 - 코드에서 발생 가능한 예외 사항을 사전 파악 후 적절한 처리를 해두면 앱의 꺼짐을 막을 수 있다
 - 유저에게 더 많은 정보를 제공할 수 있다
 */

/*
 if let vs guard let
 ✔ 값이 있을 때만 특정 코드 블록을 실행? → if let
 ✔ 값이 없으면 함수 실행 자체를 중단? → guard let
 ✔ 옵셔널 바인딩한 변수를 이후에도 계속 사용? → guard let
 ✔ 특정 조건에서만 실행하고 변수는 필요 없음? → if let
 */

func divideTwoNum(a: Int, b: Int) -> Int {
    return a / b
}

func divideTwoNum2(a: Int, b: Int) -> Int? {
    if b == 0 {
        return nil
    }
    
    return a / b
}

// 에러를 정의(열거형)
enum Divisonrror: Error {
    case zeroError
}

// https://green1229.tistory.com/507
// MARK: - [참고] 문자열을 확장을 해서 에러 프로토콜 채택을 하면 문자열 자체가 에러 타입으로 쓰일 수 있다
// @retroactive: Swift가 이후 프로토콜을 기본 제공하면 컴파일러가 자동 중복을 감지하여 @@retroactive을 제거하라고 제안한다
extension String: @retroactive Error {
    
}

// 에러를 던질 수 있는 함수를 정의(함수 내부에서 예외적인 상황이 발생할 수 있는 함수)
func divideTwoNum3(a: Int, b: Int) throws -> Int {
    if b == 0 {
        // 예외적인 상황에 에러를 던지겠다
        throw Divisonrror.zeroError
    }
    return a / b
}

func divideTwoNum4(a: Int, b: Int) throws -> Int {
    if b == 0 {
        // 예외적인 상황에 에러를 던지겠다
        throw "0으로 나누어서 발생하는 에러!"
    }
    return a / b
}

// 다른 함수 내부에서 다시 에러를 던질 수도 있다
func doSomething() throws -> Int {
    return try divideTwoNum3(a: 10, b: 0)
}


@main
struct Main {
    static func main() {
     
        // 1. 정상적인 경우
        print(divideTwoNum(a: 6, b: 3))
        
        // 2. ❌ [Error] 0으로 나누는 것은 불가능하여 앱이 꺼질 수 있다. (실제로 CPU 동작에서도 에러 발생)
        // print(divideTwoNum(a: 6, b: 0))
        
        // 3. 앱이 꺼지지 않는다
        if let result = divideTwoNum2(a: 6, b: 0) {
            print(result)
        } else {
            // nil인 경우
            print("0으로 나누었습니다")
        }
        
        // 4. [에러처리] 유저들이 앱 사용시 조금 더 많은 정보를 제공하는 방법
        do {
            // do 블럭 안에서 에러를 던지는 함수를 try를 붙여서 실행을 해야 한다
            let result = try divideTwoNum3(a: 6, b: 0)
            print(result)
        } catch {
            // 에러 발생시 catch문에서 받아서 처리 가능
            // error를 구체적인 내가 정의한 열거형 타입으로 타입캐스팅을 한다음 error변수로 사용 가능
            let error = error as! Divisonrror
            
            switch error {
            case .zeroError:
                print("나눌 숫자가 0인 경우")
            }
        }
        
        // 5. (편의적인 방법) 에러를 던지는 함수에서 에러를 던지는 상황이면 nil을 반환하고 그렇지 않으면 Optional로 반환한다
        let result = try? divideTwoNum3(a: 6, b: 0)
        print("몫:", result ?? "나눌 숫자가 0인 경우")
        
        // 6.
        do {
            let result = try divideTwoNum4(a: 6, b: 0)
            print("몫:", result)
        } catch {
            let error = error as! String
            print(error)
        }
        
        // 7. 다른 함수 내부에서 다시 에러를 던질 수도 있다
        do {
            _ = try doSomething()
        } catch {
            let error = error as! Divisonrror
            
            switch error {
            case .zeroError:
                print("나눌 숫자가 0인 경우")
            }
        }
    }
}



