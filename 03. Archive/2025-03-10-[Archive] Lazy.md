---
title: "[Archive] Lazy"
tags: 
- Archive
use_math: true
header: 
  teaser: 

---

### Memory

- iOS에서 App 사용량이 높아지면 앱을 중지시키기 때문에 메모리 관리를 신경 써야한다.
- 실제로 필요한 경우가 아니라면 비싼 코스트의 작업을 지양해야 한다.
- Swift에서 비싼 코스트 작업을 in-time 계산할 수 있게 하는 lazy variables 메커니즘을 제공한다.
- lazy variables는 변수가 처음 요청되었을 때만 사용자가 지정한 함수를 사용하여 생성된다.
- 요청하지 않는다면 지정된 함수는 절대 불리지 않고 이는 processing time을 절약해준다.

### Lazy

***Lazy 변수는 이것이 처음 사용되기 전까지 초기값이 계산되지 않는 프로퍼티이다.*** 

***사용자는 선언부에 lazy 수정자를 붙임으로써 lazy 저장 변수를 나타낼 수 있다.***

- 사용자는 항상 lazy 프로퍼티를 variable로 선언해야 한다.
- 이유: 프로퍼티의 초기값을 인스턴스 초기화가 완료된 시점까지 알 수 없기 때문이다. 그래서 상수 프로퍼티는 초기화가 끝나기 전까지 반드시 값을 가져야 하기 때문에, lazy로 선언할 수 없다.

### Lazy 사용 이유

- 이미지와 같이 일반적으로 메모리공간을 많이 차지하는 곳에서 사용한다.
- 다른 프로퍼티를 의존(이용)해야할 때 사용한다.

### Lazy 장단점

장점

- lazy 변수는 필요에 따라 효율적으로 자원관리가 가능하다. 무거운 작업이지만 자주 사용하지 않는 특정 상황에서 성능 향상에 도움을 줄 수 있다
- profileURL 변수를 초기화 시키는데 만약 userName, email이 설정되지 않은 상태에서 profileURL을 출력하게 되면 ??

→ 정확히는 출력되는 상황도 존재하지만 빈 문자열이 되거나 임시로 지정한 값으로 설정되어 원하는 동작을 못하게 될 수 있다.

→ 원하는 동작을 수행할 수 있게 profileURL을 lazy하게 선언하여 해당 프로퍼티를 초기화 시키지 않고, 사용을 할때 초기화되고 userName, email 값을 사용하여 더 안전하게 만들 수 있다.

```swift
class UserProfile {
    var userName: String
    var email: String

    var profileURL = "http://example.com/users/\(userName)?email=\(email)"
    
    lazy var profileURL: String = {
    return "http://example.com/users/\(userName)?email=\(email)"
		}()

    init(username: String, email: String) {
        self.username = username
        self.email = email
    }
}
```

단점

- 멀티 쓰레딩야 취약하다.(**여러 쓰레드에서 접근이 취약하고 안전하지 못하다)**
- 다중 스레드에서 해당 변수에 접근했을 때, 한번만 초기하 되는 것이 보장되지 않는다. 즉 thread safe하지 않다.

### Lazy Example

```swift
struct Developer {
    var isiOS: Bool?
    
    lazy var iOSDeveloper: String = {
        return "I am iOS Developer"
    }()
    
    lazy var androidDeveloper: String = {
        return "I am android Developer"
    }()
}

// 결과
// 접근하지 않은 lazy 프로퍼티는 미초기화 상태(uninitialized state)라고 부른다
// 즉 아직 초기화 되지 않았으므로 nil이 아니라 해당 로퍼티의 초기화가 지연된 상태이다
var person = Developer()
person.isiOS = true

if !person.isiOS! {
    print(person.androidDeveloper)
} else {
    print(person.iOSDeveloper)
}
```

### Lazy Stored Property vs Stored Property

- lazy property와 관련된 클로저는 오직 그 프로퍼티를 읽을 때만 실행된다. 따라서 사용자의 판단에 그 프로퍼티가 잘 사용되지 않는다면, 사용지는 불필요한 할당과 실행을 방지할 수 있다.
- lazy property를 stored property값으로 채울 수 있다.
- lazy property의 클로저 안에 self를 사용할 수 있다.(이는 순환 참조 발생시키지 않는다)
- lazy 변수의 초기화에 사용되는 클로저에는 `@noescape`가 자동적으로 적용된다. 따라서 외부에서 접근하는 것이 아니므로 캡처를 할 필요가 없다.
- 즉 클로저는 정의된 함수나 메서드가 리턴하기 전에 실행되고 완료되어야 한다.
- 이로 인해 컴파일러는 이 클로저가 메모리에서 유지될 필요가 없다는 것을 알고 자동으로 클로저 내에서 self를 강한 참조로 캡처하지 않는다.
- 즉 클로저 내에서 self를 사용해도 강한 참조 순환을 걱정안해도 된다. 초기화 클로저는 프로퍼티가 처음 접근될 때만 실행되며, 그 후에는 클로저가 메모리에서 해제되기 때문이다.
- computed property와 함꼐 사용불가. 이유는 computed property는 computation 블록 안의 코드가 모두 실행되고 난 다음에 값을 반환하기 때문이다.
- lazy 변수는 struct or class멤버로만 사용 가능하다.
- lazy 변수는 자동으로 초기화되지 않기 때문에 thread safe하지 않다.
- lazy 변수는 처음 request될 때 초기화되고 그 다음엔 계속 그 값을 저장한다. 따라서 처음 값을 계속 유지한다.

### Reference

- https://hyunndyblog.tistory.com/155
- https://velog.io/@niro/Swift-Lazy-%EC%A7%84%EC%A7%9C-%ED%95%84%EC%9A%94%ED%95%A0-%EB%95%8C%EB%A7%8C-%EC%94%81%EC%8B%9C%EB%8B%A4
- https://wansook0316.github.io/dv/ios/2021/08/08/iOS-Exprience-10-Lazy%EB%A5%BC-%EC%95%88%EC%93%B0%EB%8A%94-%EC%9D%B4%EC%9C%A0.html
- https://ios-daniel-yang.tistory.com/entry/iOSSwift-%EC%86%8D%EC%84%B1Properties%EC%9D%98-%EC%A2%85%EB%A5%98#article-3--%EC%A7%80%EC%97%B0-%EC%A0%80%EC%9E%A5%EC%86%8D%EC%84%B1(lazy-stored-properties)
