import UIKit

/*
 
 (201강)
 문자열 다루기
 - 스위프트는 대문자와 소문자를 다른 문자로 인식(유니코드 다름)
 
 */

// MARK: 앱개발시 주로 사용
var string = "swift"
string.lowercased() // 전체 소문자로 바꾼 문자열 리턴(원본 그대로)
string.uppercased() // 전체 대문자로 바꾼 문자열 리턴(원본 그대로)
string.capitalized // 문자열의 맨 앞글자만 대문자로 리턴한다(원본 그대로)

"swift" == "Swift" // false
"swift".lowercased() == "Swift".lowercased() // true

// MARK: count, isEmpty: 데이터 바구니에서 자주 사용하는 속성
var emptyString = " " // 공백문자열
emptyString.count     // 1
emptyString.isEmpty   // false


emptyString = ""    // 빈 문자열(메모리공간 차지한다) nil아니다!
emptyString.count   // 0
emptyString.isEmpty // true

// MARK: 빈문자열, 공백문자열 차이가 있다, 유니코드도 다르다

var test: String?
if test == nil {
    print("nil")
}



// MARK: 제일 중요한부분: String Index타입
var array = [1, 2, 3, 4, 5] // 인덱스 색인이 매겨져서 서브스크립트 문법으로 접근 가능하다


// MARK: String의 인덱스의 경우 정수 형태로 매겨지지 않는다


/*
 정수배열에는 정수만 들어있음
 메모리에 저장할 때 메모리 주소 간격이 일정하다
 - 이유: 하나의 Int를 저장하기 위해 사용하는 메모리 공간이 동일하다
 - 그래서 빠르게 메모리에 저장되어있는 숫자를 빠르게 접근 가능
 
 
 
 문자열에서는 정수형태의 인덱스 사용못하는 이유
 - 문자열은 저장하기 위해 서로 다른 데이터 공간을 사용할 수 있다
 - H는 1칸, i는 1칸, 이모지 4칸...
 - 그래서 swift에서 정수형태 인덱스 막아두었다
 
 
 문자열도 Collection 프로토콜을 따르고 있다 => 데이터 바구니 역할을 한다
 
 */



/**============================================================
 - 문자열의 인덱스는 정수가 아님 ⭐️
 - (스위프트는 문자열을 글자의 의미단위로 사용하기 때문에, 정수 인덱스 사용 불가)
 
 [String.Index 타입]
 - 문자열.startIndex
 - 문자열.endIndex
 - 문자열.index(<#T##i: String.Index##String.Index#>, offsetBy: <#T##String.IndexDistance#>)
 
 - 문자열.index(after: <#T##String.Index#>)
 - 문자열.index(before: <#T##String.Index#>)
 - (다만, 인덱스의 크기 비교는 당연히 가능)
 
 - 문자열.indices     (인덱스의 모음)
 - (인덱스를 벗어나는 것에 주의)
 
 
 - 문자열.firstIndex(of: <#T##Character#>)
 - 문자열.lastIndex(of: <#T##Character#>)
 
 
 [String.Index 범위]
 - 문자열.range(of: <#T##StringProtocol#>)
 - 문자열.range(of: <#T##StringProtocol#>, options: <#T##String.CompareOptions#>, range: <#T##Range<String.Index>?#>, locale: <#T##Locale?#>)
 
 
 - String.Index를 이용, 서브스크립트 활용가능 ⭐️
 
 
 [String.Index의 정수형태로 거리는 측정 가능]
 - 문자열.distance(from: <#T##String.Index#>, to: <#T##String.Index#>)
 ==============================================================**/


let greeting = "Guten Tag!"
greeting.startIndex
print(greeting.startIndex)

// MARK: 서브스크립트 문법을 쓸 수 없는게 아니라 정수 형태의 인덱스를 사용할 수 없다!!!
var firstIndex = greeting.startIndex
print(greeting[firstIndex]) // G


// 정수형태를 한번 변형해서 사용하는 방식
// MARK: startIndex로부터 2만큼 떨어진 index를 뽑아내겠다
var someIndex = greeting.index(greeting.startIndex, offsetBy: 2)
greeting[someIndex] // u


// 앞에서부터 G를 찾아서 인덱스 뽑아준다
var newIndex = greeting.firstIndex(of: "G")!
greeting[newIndex]


// 정수형태를 한번 변형해서(걸러서) 사용하는 방식 ⭐️
someIndex = greeting.index(greeting.startIndex, offsetBy: 2)
greeting[someIndex]      // "t"


someIndex = greeting.index(greeting.startIndex, offsetBy: 1)
greeting[someIndex]      // "u"


someIndex = greeting.index(after: greeting.startIndex)
greeting[someIndex]      // "u"


someIndex = greeting.index(before: greeting.endIndex)
greeting[someIndex]      // "!"

greeting[greeting.index(greeting.endIndex, offsetBy: -1)]
greeting[greeting.index(before: greeting.endIndex)]

// 범위 벗어나기 방지
someIndex = greeting.index(greeting.startIndex, offsetBy: 7)


if greeting.startIndex <= someIndex && someIndex < greeting.endIndex { // 범위를 벗어나지 않는 경우 코드 실행
    print(greeting[someIndex])
}

// 문자열 특정범위를 추출
// 인덱스를 직접 뽑아낼 수 있음
let lower = greeting.index(greeting.startIndex, offsetBy: 2)
let upper = greeting.index(greeting.startIndex, offsetBy: 5)
greeting[lower...upper] // 범위를 뽑아낼 수 있다

// 인덱스의 범위를 뽑아낼 수 있음
var range = greeting.range(of: "Tag!")!
greeting[range]

// 대소문자 상관없이알려줘
range = greeting.range(of: "tag", options: [.caseInsensitive])!
print(range)

greeting.distance(from: <#T##String.Index#>, to: <#T##String.Index#>)
