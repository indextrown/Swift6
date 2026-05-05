/*
 
 (56강) 열거형과 switch문의 활용
 
 열거형
 - 거의 switch문과 사용
 */


// 원시값 설정
enum LoginProvider: String {
    case email
    case facebook
    case google
}

let userLogin = LoginProvider.facebook

switch userLogin {
case .email:
    print("이메일 로그인")
case .facebook:
    print("페이스북 로그인")
case .google:
    print("구글 로그인")
}

// 한가지 경우만 처리할 떄
if LoginProvider.email == userLogin {
    print("이메일 로그인")
}

// 열거형에 (연관값이 없고), 옵셔널 열겨형의 경우
// 옵셔널 열겨형: 열거형 저체에 ?를 붙혔다
enum SomeEnum {
    case left
    case right
}

// 옵셔널 자체도 열거형 구현인데 다시 열거형으로 구현 되어있다
// 열거형의 내부에 다시 열거형이 구현되어있다
// 옵셔널 타입 자체도 열거형
let x: SomeEnum? = .left
