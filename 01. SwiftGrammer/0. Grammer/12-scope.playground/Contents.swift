
/*
 

 
 (33강) 범위(Scope)에 대한 이해
 
 command + a
 control + i -> 들여쓰기 보장
 
 // 현재 name이 전역변수라서 가능
 범위 = 중괄호
 밖에서 중괄호 내의 변수 접근 불가능
 중괄호 내에서 밖으 변수 접근 가능

 스코프
 - 변수는 코드에서 선언이 되어야 접근 가능(선언하기 이전에 접근 불가)
 - 상위 스코프에 선언된 변수와 상수에 접근가능, 하위 스코프는 불가
 - 동일한 스코프에서 중복 불가 but 다른 스코프에서 중복 가능 가장 인접한 스코프에 있는 변수와 상수에 먼저 접근

 함수 실행 전에 변수가 선언되어 있어야함
 
 */




//func greeting1() {
//    print("Hello")
//    
//    var myName = "김동현"
//    
//    print(myName)
//    print(name)
//    
//    if true {
//        print(myName)
//        print(name)
//    }
//}


//greeting1()
//let name = "hello"
//greeting1() //  가능-> 함수 실행 전에 변수가 선언되어 있어야함


func sayGreeting() {
    print("Hello")
    func sayGreeting2() {
        print("Hey")
    }
    sayGreeting2()  // 밖에서는 실행 불가
}

sayGreeting()
