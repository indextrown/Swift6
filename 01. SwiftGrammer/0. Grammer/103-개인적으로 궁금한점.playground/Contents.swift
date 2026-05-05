//[기존에 구조체를 배운 지식]
//- 모든 속성을 명시적으로 초기화하는 "생성자" 필요하다
//- Swift는 구조체에 대해 멤버와이즈 이니셜라이저를 자동으로 제공한다



/*
 
 [궁금한점]
 - swift에서 기본 타입들은 구조체임에도 불구하고 var a: Int = 0이 가능한 이유가 궁금하였다
 
 
 [기존 구조체 관련 지식]
 - 일반적으로 구조체는 인스턴스를 생성할 때 명시적으로 생성자(initializer)를 호출해야 한다
 - 예를 들어, 구조체가 MyStruct라는 이름으로 정의되어 있다면, MyStruct() 같은 방식으로 인스턴스를 생성해야 한다
 - Int 같은 기본 데이터 타입은 이러한 명시적인 생성자 호출 없이, 리터럴 값(예: 0, 1, 42)만으로도 인스턴스를 생성할 수 있다.(어떻게???)
 
 
 [결론]
  - Int 구조체가 리터럴 초기화를 가능하게 하는 이유는 `ExpressibleByIntegerLiteral` 프로토콜을 준수하기 때문이다
  - 해당 프로토콜을 준수하는 타입은 정수 리터럴로 초기화될 수 있다
  - Int 타입의 인스턴스를 생성하기 위해 별도 생성자를 호출할 필요 없이, 리터럴 값으로 Int 타입의 변수를 초기화할 수 있다
  
  
 [느낀점]
 - Swift에서 프로토콜은 타입의 기능을 확장하고, 직관적인 코딩을 가능하게 하는 중요한 도구이다
 
 */















// swift에서 기본 타입들은 구조체임에도 불구하고 var a: Int = 0이 가능한 이유가 궁금하였다
var num: Int = 5
print(num)







// MyInt는 리터럴 초기화를 지원하지 않기 때문에, 아래의 코드는 컴파일 에러 발생한다
struct MyInt {
    // 리터럴 초기화 지원 코드가 없음
    var num: Int
}

// 컴파일 에러
//var test: MyInt = 0






// `ExpressibleByIntegerLiteral` 프로토콜을 준수하면 리터럴 값으로 변수를 초기화할 수 있다.
struct MyInt2: ExpressibleByIntegerLiteral {
    var num: Int
    
    init(integerLiteral value: Int) {
        self.num = value
    }
}

// 가능
var test: MyInt2 = 10
print(test)















