// 함수 표기법(지칭)
/*
 
 - 함수의 실행문이 아닌 함수를 지칭하는것
 - 파라미터 없을 때는 소괄호 생략
 
 func test() -> String {
     return "hello"
 }

 // 함수표기법: 함수를 가리킬 때 사용
 - 함수를 실행하는게 아니라 지칭할 때 사용
 var test2 = test
 print(test2())
 
 func test3(say: String) {
     print(say)
 }

 var test4 = test3(say:)
 test4("hi")

 // 함수표기밥: 매개변수 있을때 함수 가리킬 때 사용
 var test4 = test3(say:)
 test4("hi")

 func test5(say1: String, say2: String) {
     print(say1 + say2)
 }

 // 함수표기밥: 매개변수 여러개일 때 함수 가리킬 때 사용
 var test6 = test5(say1:say2:)
 test6("hello", "world")

 함수의 타입,자료형
 - () -> ()
 - () -> void
 
 
 */


// 실행문
// doSomething()

// 함수를 가리킴
// doSomething
// 정의한 함수는 some이라는 이름도 가짐
// 함수를 가리키는데 필요시 사용
// some 변수도 doSomething()을 가리킴, !!실행은 아님!!
// var some = doSomethihg
// some()



func test() -> String {
    return "hello"
}

// 함수표기법: 함수를 가리킬 때 사용
var test2 = test
print(test2())


func test3(say: String) {
    print(say)
}

// 함수표기밥: 매개변수 있을때 함수 가리킬 때 사용
var test4 = test3(say:)
test4("hi")

func test5(say1: String, say2: String) {
    print(say1 + say2)
}

// 함수표기밥: 매개변수 여러개일 때 함수 가리킬 때 사용
var test6 = test5(say1:say2:)
test6("hello", "world")

