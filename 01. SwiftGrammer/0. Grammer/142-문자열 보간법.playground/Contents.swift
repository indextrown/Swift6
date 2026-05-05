/*
 
 (197강)
 문자열 보간법
 
 문자열 보간법이란(String Interpolation)
 - 여러 언어에서 각각의 방법으로 쓰임
 - 상수, 변수, 리터럴 값, 그리고 표현식의 값을 표현 가능
 - 문자열 리터럴 내애서 \()로 사용하는 표현방법
 
 표현식
 - 어떤 하나의 결과값으로 나오는것
 */
import UIKit


let name = "유나"
print("브레이브걸스: \(name)")
print("브레이브걸스: \(5)") // 리터럴 값도 가능
print("브레이브걸스: \(name + " 단발좌")") // 표현식도 가능

let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
print(message)


// String Interpolation의 동작원리는 뭐지?
struct Dog {
    var name: String
    var weight: Double
}

// 붕어빵을 찍어낸다
let dog = Dog(name: "초코", weight: 15.0)

// 동일한 방식으로 출력된다
// 구조체가 출력되는 방식은 출력 형태를 미리 애플이 정해놓았다 Dog(name: "초코", weight: 15.0)
// 인스턴스를 String Interpolation로 출력하면 문자열 자체로 인식한다
print("\(dog)")
print(dog)

// 더 자세하게 출력
// 인스턴스를 dump로 출력하면메모리 구조상에 어떤 방식으로 저장되어있는지 출력
dump(dog)
dump(dog)



/*
 String Interpolation 자세히 알아보자
 - 개발자인 우리가 출력 형태에 대한 지정을 직접적으로 지정할 수 있다
 
 어떻게?
 CustomStringConvertible 프로토콜이(자격증) 있다
 이 자격증이 요구하는 것은 description 속성을 구현하는 것이다
 만약 CustomStringConvertible을 채택하면 description 속성만 구현해주면 된다
 이 프로토콜이 의미하는 바가 무엇인가?
 - 채택을 하게되면 우리가 원하는 방식으로 출력 가능해진다
 
 protocol CustomStringConvertible {
    var description { get }
 }
 
 */

// 강아지 이름은 초코이고, 몸무게는 15.0kg 입니다 출력
// CustomStringConvertible을 채택해야한다
// Swift 4방식
extension Dog: CustomStringConvertible {
    var  description: String {
        return "강아지 이름은 \(name)이고, 몸무게는 \(weight)kg 입니다"
    }
}
print("test")
print(dog)
print("\(dog)")

// 결과적으로 String Interpolation 썼을 때 그 인스턴스의 형태를 찾아가서 프로토콜을 채택했다면 description 속성에 구현된 부분을 읽고 출력해준다.

// \() ===> description 변수를 읽는 것






// Swift 5부터 멋있게 바뀜
/*
 문자열 보간법을 메서드 실행방식으로 바꾸면서 활용도가 높아졌다(다른 파라미터 지정도 가능)
 */


struct Point {
    let x: Int
    let y: Int
}

let p = Point(x: 5, y: 7)

print(p) // Point(x: 5, y: 7) --> 애플이 이런 식으로 출력을 하겠다고 정해놓았다
print("\(p)")

// 직접적으로 우리가 구현할 수 있다
// String.StringInterpolation에 확장해서 구현을 해야한다
extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: Point) {
        appendInterpolation("X좌표는 \(value.x), Y좌표는 \(value.y)입니다.")
    }
    

}

print("\(p)")
print("\(dog)")



/* 
 MARK: Swift4까지의 방식은 각자의 타입에다가 구현하는 방식이었다
 
 MARK: 현재는 각자의 타입에 구현하는게 아니라 문자열 자체에 기능이 내장되어 있어서 문자열 자체에 타입에 대한 출력 방식을 구현을 해준다
 appendInterpolation()메서드를 만들어줘야한다

*/


/**=====================================
 스트링 인터폴레이션을 호출하는것은 결국 appendInterpolation메서드를 실행하는 개념이다
 메서드로 바뀌면서 활용도가 높아짐
 - 다른 파라미터 지정이 가능하다
- \( ) ====> appendInterpolation()을 실행
========================================**/

extension String.StringInterpolation {

    mutating func appendInterpolation(_ value: Point, style: NumberFormatter.Style) {
        
        // "숫자" <====> "문자" 변환을 다루는 객체
        let formatter = NumberFormatter()
        formatter.numberStyle = style

        // 지정된 스타일로 문자열을 구성
        if let x = formatter.string(for: value.x), let y = formatter.string(for: value.y) {
            appendInterpolation("X좌표는 \(x) x Y좌표는 \(y)")
        }else  {
            appendInterpolation("X좌표는\(value.x) x Y좌표는\(value.y)")
        }
    }
    
    mutating func appendInterpolation(_ value: Dog) {
        appendInterpolation("강아지의 이름은 \(value.name)이고, 몸무게는 \(value.weight)입니다.")
    }
}

// MARK: 활용도가 높아졌다~~
//extension String.StringInterpolation {
//                                             MARK: 일반적으로 이렇게 파라미터 추가 안함
//    mutating func appendInterpolation(_ value: Point) {
//        
//        // "숫자" <====> "문자" 변환을 다루는 객체
//        let formatter = NumberFormatter()
//        formatter.numberStyle = style
//
//        // 지정된 스타일로 문자열을 구성
//        if let x = formatter.string(for: value.x), let y = formatter.string(for: value.y) {
//            appendInterpolation("X좌표는 \(x) x Y좌표는 \(y)")
//        }else  {
//            appendInterpolation("X좌표는\(value.x) x Y좌표는\(value.y)")
//        }
//    }
//    
//    mutating func appendInterpolation(_ value: Dog) {
//        appendInterpolation("강아지의 이름은 \(value.name)이고, 몸무게는 \(value.weight)입니다.")
//    }
//}


// MARK: 단순히 인스턴스를 스트링 인터폴레이션으로 출력할 수 있다
print("\(p)")

// MARK: 메서드 방식으로 넘어오면서 스트링 인터폴레이션을 아예 메서드처럼 파라미터를 입력하는 방식으로 구현해볼 수 있다
// MARK: 숫자를 영어로 바꿔서 출력
print("\(p, style: NumberFormatter.Style.spellOut)")     // X좌표는 five x Y좌표는 seven

// MARK: 숫자를 %로 표현해라
print("\(p, style: .percent)")      // X좌표는 500% x Y좌표는 700%

// MARK: 숫자를 과학적인 표현법으로 표현해라
print("\(p, style: .scientific)")   // X좌표는 5E0 x Y좌표는 7E0

// MARK: 숫자에 달러를 붙여주는 방식으로 표현해라
print("\(p, style: .currency)")



// NumberFormatter: 애플이 미리 지정해놓은 스타일을 자유롭게 변형할 수 있다
// DateFormatter: 데이터 형식을 문자열로 변환을 자유롭게 변형할 수 있다
/**===================================
(참고용) NumberFormatter.Style 열거형으로 정의

  enum Style : UInt {
      case none = 0
      case decimal = 1
      case currency = 2
      case percent = 3
      case scientific = 4
      case spellOut = 5
      case ordinal = 6
      case currencyISOCode = 8
      case currencyPlural = 9
      case currencyAccounting = 10
  }
=====================================**/


