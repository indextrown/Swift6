
/*
 
 (39강) guard문(7-8파일)
 
 guard문
 - 감시하다
 - if문과 유사하게 쓰이는 문
 - if문 불편하기 때문에 사용
 - swift언어에서 유일
 
 if문 단점
 - 여러개의 조건이 있을 때 코드의 가독성 문제 -> guard문으로 단점 극복
 
 if문
 - 어떤 조건을 만족했을 때 중괄호 내부의 문장을 실행시키는것 만족하지 않으면 한참 밑으로 내려와서 else문을 찾아 실행시킨다
 
 guard문
 - 반드시 early exit개념이 else문에 반드시 들어가야함.  (함수에서의 early exit: return) 즉 종료
 - 조건을 만족시켜서 조기 종료를 시키는 의도이다
 - 코드 내부로 들어갈 필요가 없다
 - 조건을 만족하지 않는 경우 먼저 else문을 실행시킨다. -> 일찍 종료시키겠다 = early exit
 - else 조건문이 먼저 등장하는 if문이다... 라고 생각하자
 
 
 
 */

// 기존 if문 햇갈림 -> 불편함
if true {
    print("1")
    
    if true {
        print("2")
        if true {
            print("3")
        }
    }
}


func checkNumberOf1(password: String) -> Bool {
    if password.count >= 6 {
        // 로그인 처리 과정
        return true
    } else {
        return false
    }
}

// 2
func checkNumberOf2(password: String) -> Bool {
    // 조건을 만족하는지 감시하다
    // 패스워드 6자리 이상인지 먼저 감시하고 이 감시하는 조건에 맞지 않으면 else문 먼저 실행시킨다
    guard password.count >= 6 else {
        return false
    }
    return true
}

// 3
// 2와 3은 같음
// 어떤 조건을 만족하면 계속 아래 줄로 내려가서 실행한다
func checkNumberOf3(password: String) -> Bool {
    guard password.count >= 6 else { return false } // 계속 추가
    guard true else {return false}  // 계속 추가
    // guard 조건을 만족하면 아래로 내려감
    // .
    // .
    // .
    return true
}

// 문자열 개수 확인
func checkwords(words: String) -> Bool {
    guard words.count >= 5 else {
        print("5자리 이상 입력하세요. ")
        return false
    }
    
    // 조건을 만족하면
    print("\(words.count)글자입니다. ")
    return true
}

var test = checkwords(words: "abc")
