//
//  1.swift
//  Swift5
//
//  Created by 김동현 on 2/3/25.
//

// MARK: - self 키워드(공식문서 클로저 내용과 유사)
// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures
import Foundation
import SwiftUI

var 함수저장변수: (() -> Void)?

// MARK: - 파라미터가 escapingclosure로써 쓰이는경우와 아닌 경우
// MARK: - 함수 파라미터가 heap에 저장되어 오래동안 쓰임 => 캡처현상 발생가능
func escapingClosure(함수파라미터: @escaping () -> Void) {
    /*
     @escaping 필수 이유
     - input으로 쓰이는 함수가 외부 변수에 저장이 되기 때문에 실행 중인 함수를 벗어나더라도 파라미터가 쓰이기 떄문
     - 함수는 참조타입이라 함수가 외부 변수에 저장되면 heap이라는 메모리 영역에 클로저가 생긴다 = 클로저가 heap에 저장되어 오래동안 쓰일 수 있다 => 외부변수를 참조하면 캡처현상 발생 가능
     */
    함수저장변수 = 함수파라미터
}

// MARK: - 함수 파라미터가 heap에 저장되지 않아 오래동안 쓰이지 않음 => 캡처현상 발생x
func nonEscapingClosure(함수파라미터: () -> Void) {
    /*
     @escaping 필요없는 이유
     외부 변수에 저장하는 작업이 아니라 파라미터로 들어온 함수를 실행만 시키고 있기 때문에
     */
    함수파라미터()
}

// MARK: - 클래스 내에서 클로저 사용시 어떤 경우는 self를 반드시 붙혀야 하고 어떤 경우는 안붙힌다
class 클래스 {
    var x = 10
    func doSomething() {
        
        /*
         MARK: - escapingClosure에서는 반드시 self를 붙여줘야 하는 이유: 캡처현상이 발생할 수 있기 때문
         - 클로저 입장에서 보면 x라는 변수가 외부 변수인데 x만 캡처를 하는 게 아니라 x를 소유하고 있는 self 자체를 캡처하기 때문에
         escapingClosure에서는 self가 캡처가 될 수 있으니까 캡처를 주의해서 사용해라는 명시적으로 self를 붙혀야 한다
         */
        escapingClosure { /// [self] in 명시적으로 self를 작성하거나 클로저의 캡처 리스트에 self를 포함
            self.x = 100  /// 명시적 self참조(나중에 사용할꺼니까, self 캡처할거야) // 나중에 호출시 실행
        }
        
        /*
         MARK: self를 안붙혀도 된다
         - self가 암시적으로 참조되기 때문이다
         - self에 대해 캡처현상이 일어나는 상황은 아니다
         */
        nonEscapingClosure {    /// 즉시 실행
            x = 200             /// 암시적 self 참조(self붙혀도 되긴 함)
        }
        DispatchQueue.global().async { /// 본질적으로 @escaping 클로저 (heap에 저장됨)
            self.x = 300
        }
    }
}

// MARK: - self가 구조체 또는 열거형 인스턴스이면 항상 암시적으로 self를 참조한다
// MARK: - 값타입이라서 참조 타입의 캡처가 일어나지 않기 때문에 self를 쓸 필요 없다(문법적 약속)
// MARK: - 구조체나 열거형의 저장속성을 바꾸려면 mutating 키워드를 붙혀줘야한다
// - 값타입인 경우 항상 복사가 되서 사용이 되기 때문에 자기 자신을 바꿀 수 없는게 원칙인데 mutating 키워드를 통해 자기 자신을 바꿀 수 있다
struct 구조체 { //  값타입
    var x = 10
    
    mutating func doSomething() {
        
        // self에 대한 변경 가능한 참조를 캡처할 수 없음(값타입이라 값복사가 일어나야한다, 원본은 바꿀 수 없다)
        /*
        escapingClosure {
            self.x = 100        // ❌ [ERROR]: Escaping closure captures mutating 'self' parameter
        }
         */
        
        nonEscapingClosure {
            x = 200         /// 암시적으로 self 참조
        }
    }
}

/*
 [공식문서 설명]
 - mutating 함수 내부에서 escapingClosure 함수를 호출하는 것은 오류이다.
 - 이유: escapingClosure가 mutating 메서드 내에 있기 때문에 mutating이 붙은 함수 내부에서만 self를 변경할 수 있기 때문.
        dosomething함수를 벗어나서 즉 mutating 키워드가 영향을 미칠 수 있는 범위를 벗어나서 self를 변경해주고 있기 때문에 오류가 발생한다.
 - 이는 탈출 클로저가 구조체(값타입)에 대해 변경 가능한 self 참조를 캡처할 수 없다는 규칙을 위반한것이다.
 - 해결법: 클래스로 바꿔야 한다.
 */


@main
struct Main {
    static func main() {
        
    }
}

