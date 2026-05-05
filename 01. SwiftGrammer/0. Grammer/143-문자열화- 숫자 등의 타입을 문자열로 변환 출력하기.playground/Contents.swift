/*
 
 (198강)
 숫자(정수/실수) 등을 문자열로 변환 출력하려고 할때
 
 */

import UIKit
var pi = 3.1415926
print("원하는 숫자는 \(pi)")

/* 반올림 하는법(2가지 방법)
 1) 출력 형식 지정자 사용
 
 2) NumberFormatter
 
 */
var string: String = ""

// Double타입의 문자열로 변환
// 사실 ()는 생성자 즉 새로운 문자열을 생성하고 있는 것이다
// 즉 타입을 변환을 하는게 아니라 새롭게 생성하고 있는것이다
string = String(3.1415926) // 출력된 형태는 문자열
print(string)

// MARK: 문자열 생성자중 특이한 녀석이 존재
// %: 큰 의미가 있는게 아니라 약속이다. 이런 방식을 쓰면 형식을 지정할 수 있다. 형식 지정에 대한 모든 것을 의미한다
// .을찍고 숫자를 적으면 .3: 소수점 아래 3자리
// f는 실수를 의미한다
print("원하는 숫자는 " + String(format: "%.3f", pi))
print("원하는 숫자는 " + String(format: "%.2f", pi))
print("원하는 숫자는 " + String(format: "%.1f", pi))


//MARK: 출력 형식 지정자 종류(절대 외우기 금지)

// d는 정수를 의미한다
string = String(format: "%d", 7)
print(string)

string = String(format: "%2d", 7) // 정수 2자리 의미
print(string)

string = String(format: "%02d", 7)// 정수 2자리인데 앞에 남는 자리가 있으면 0을 넣겠다
print(string)

// 일곱자리로 표현하되 0과 .(dot) 포함, (소수점아래는 3자리)
string = String(format: "%07.3f", 3.1415926) // 소수점아래3자리고 전체 자리는 7자리고 남는게 있으면 0을 더하겠다
print(string) // 003.142


var swift = "Swift"
// 내가 변환하고싶은 문자열 형태
string = String(format: "Hello, %1$@", swift) // %@부분에 문자열을 넣겠다
print(string)


// MARK: 형식 지정자 활용 예시
// 이전 강의에서 배운 CustomStringConvertible방식과 결합해서 활용 가능

struct Point {
    // 저장속성
    var x: Double
    var y: Double
}

// Swift4방식
extension Point: CustomStringConvertible {
    var description: String {
        // MARK: 첫번째 파라미터는 소수점 2자리, 두번째 파라미터도 소수점 2자리
        
        // MARK: 둘다 같은 방식
        // let formattedValue = String(format: "내 마음대로 변환 가능 ==> %1$.2f, %2$.2f", x, y)
        let formattedValue = "내 마음대로 변환 가능 ==> " + String(format: "%.2f,", x) + " " + String(format: "%.2f", y)
        return "\(formattedValue)"
    }
}

let p = Point(x: 3.1415926, y: 3.1415926)

// 스트링 인터폴레이션으로 호출시 formattedValue 형태로 출력하겠다
print("\(p)")


var firstName = "Gildong"
var lastName = "Hong"

var korean = "사용자의 이름은 %2$@ %1$@ 입니다."
var english = "The username is %1$@ %2$@."

string = String(format: korean, firstName, lastName)
print(string)

string = String(format: english, firstName, lastName)
print(string)




// 2) NumberFormatter 클래스를 이용하는방법(DateFormatter랑 비슷)
// Number를 문자열로 바꿔주는 형식 

// MARK: NumberFormatter를 쓰면 편하다
/**=================================
 - "숫자" <====> "문자" 변환을 다루는 클래스
 - NumberFormatter()
 
 [설정 가능 속성]
 .roundingMode              반올림모드
 .maximumSignificantDigits  최대자릿수
 .minimumSignificantDigits  최소자릿수
 .numberStyle               숫자스타일
===================================**/


// 소수점 버리기
let numberFormatter = NumberFormatter()
numberFormatter.roundingMode = .floor         // 버림으로 지정
numberFormatter.maximumSignificantDigits = 3  // 최대 표현하길 원하는 자릿수

let value = 3.1415926
var valueFormatted = numberFormatter.string(for: value)!    // 문자열화시키는 메서드
print(valueFormatted)   // 3.14



// 소수점 필수적 표현하기
numberFormatter.roundingMode = .floor         // 버림으로 지정
numberFormatter.minimumSignificantDigits = 4  // 최소 표현하길 원하는 자릿수

let value2 = 3.1
valueFormatted = numberFormatter.string(for: value2)!     // 문자열화시키는 메서드
print(valueFormatted)     // 3.100



// 세자리수마다 콤마 넣기 ⭐️
numberFormatter.numberStyle = .decimal
let price = 10000000
let result = numberFormatter.string(for: price)!
print(result) // "10,000,000"

