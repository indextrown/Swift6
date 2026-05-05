/*
 
 (44강) 옵셔널값의 추출 방법
 
 바인딩
 - 새로운 상수나 변수에 바꿔서 담는 문법적인 방법
 
 강제추출
 - 값이 있다는 것을 확신하고 강제로 값이 추출
 - var num: Int? 에 nil일 경우 에러 발생
 
 nil 아닌지 확인후, 강제추출
 - if문으로 nil 아니라는 것 확인 후 강제로 벗기기
 
 
 // 1. nil 아닌 값이 있다는 것 확신하고 강제로 값을 추출
 // 2. 값이 있으면 강제로 벗긴다
 // 3 .옵셔널 바인딩(=if let 바인딩)
 // 4. nil-coalescing(닐 코얼레싱)
 // 코얼레싱: 더 큰 덩어리로 합친다
 // 기본 값을 제시할 수 있을 때 값을 벗긴다
 
 */

var num: Int?
var str: String? = "안녕하세요"

// 1. nil 아닌 값이 있다는 것 확신하고 강제로 값을 추출
//print(num)
//print(str!)

// 2. 값이 있으면 강제로 벗긴다
if str != nil {
    print(str!)
}

if num != nil {
    print(str!)
}

// 3 .옵셔널 바인딩(=if let 바인딩)
// 값을 우아하게 벗기는 방법
// 일반적으로 if문 다음에는 조건문(참과 거짓 판별하는)이 와야함
// str을 새로운 상수에 담고 있음
// 새로운 변수에 담아진다면 내부를 실행하겠다 -> nil값이 아니라면 담겨 질것임
// 바꿔서 담긴다면 == 안에 값이 있다면 == 우아하게 벗겨진다면 사용하겠다
// str이 nil이라면 실행안하겠다
// 주로 사용함
if let s = str {
    print(s)    // string타입
}


var optName: String? = "김동현"
if let name = optName {
    print("값이 담겨서 nil이 아닙니다")
}

// 실제 앱 만들 때 guard let 바인딩 많이 사용
func doSomething(name: String?) {
    guard let n = name else {return}    // name = Optional("hello")
    print(n)                            // n    = "hello"
}

doSomething(name: optName)





// 4. nil-coalescing(닐 코얼레싱)
// 코얼레싱: 더 큰 덩어리로 합친다
// 기본 값을 제시할 수 있을 때 값을 벗긴다
//3방식
var serverName: String? = "김동현"
if let name = serverName {
    print(name)
}

// serverName = nil
var userName = serverName ?? "미인증사용자" // 기본값을 제시
// nil이 들어 있는 경우 미인증 사용자를 사용하겠다

