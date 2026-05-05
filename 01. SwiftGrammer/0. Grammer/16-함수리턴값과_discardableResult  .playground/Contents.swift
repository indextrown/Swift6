/*
 (40강)
 
 함수의 리턴값
 - 리턴값이 없 는 함수 vs 리턴값이 있는 함수
 
 cpu
 - cpu가 명령어 코드르 실행하다가 어떤 함수를 만났을 때 함수 실행하려고 코드 찾아가면
 - 제어권과 같이 해당 코드로 찾아가고 다시 원래 위치로 돌아올 때 제어권 돌아옴)
 - 리턴값이 있다면 리턴값도 같이 돌아옴
 
 @어트리뷰트 키워드(속성)
 - 컴파일러에게 추가적인 알려주는 역할(2가지 종류)
 -  1: 서면에 추가적인 정보 제공(class 앞에 붙혀서 컴파일러에게 알려줌)
 -  2: 타입에도 추가 정보 제공
 - 키워드 = 약속어(if, guard, for문: 이들은 골뱅이 표시 없음)
 - 키워드긴 키워든데
 - 2가지 종류 

 @discardableResult
 - 버릴 수 있는 결과 라고 알려줌
 _ = sayHelloString()
 - 와일드카드 = 뭔가를 생략할 때 사용
 - 안녕하세요 라는 값을 반환하는 함수인데 이 값을 생략할거야/구체적으로 사용안할거야 컴파일러에게 알려줌(swift4까지 사용한 방식)
 - swift5.2 부터 discardableResult 사용
 - 함수 선언할 때 함수 위에 바로 붙힌다
 
 
 
 
 
 (40-1강) 튜플을 사용하는 이유
 
 함수
 - 함수의 원칙: output는 한개의 return값만 가져야한다
 - 리턴값이 있는 함수는 임시 공간에 값을 넣고 값을 반환
 - 여러 개의 값 반환하고 싶을 떄는 여러 방법이 있는데 예시로 튜플이 있다
 1: 튜플(어떤 값을 묶음으로 만들어서)사용 ex)네트워크-> 유의미한 데이터가 될 수 있음
 2: 데이터바구니(배열)로 반환
 
 
 
 
 
 */

//@discardableResult // swif5.2버전이후 -> 노란색 경고창 없애줌(버릴 수도 있는 결과 컴파일러에게 알려줌)
func test() -> String {
    return "hello"
}

// swift4버전
_ = test()

test()



// 연습문제1: 문자열을 입력하면 그중 한개의 글자를 랜덤으로 뽑아주는 함수를 만들어 보자
func randString1(_ inp: String) -> Character {
    var cnt = inp.count
    var rand = Int.random(in: 0..<cnt)
    let index = inp.index(inp.startIndex, offsetBy: rand)
    return inp[index]
}
// randString1("안녕하세요")



func randString2(_ inp: String) -> String {
    return String(inp.randomElement()!) // 옵션으로 ? 있으면 !붙히면 에러 사라짐-> 값이 안나올 가능성이 있어서 발생
}
// randString2("안녕하세요")


//// 연습문제2: 소수(prime number)를 판별하는 함수를 만들어보자
//func primeNumber(_ inp: Int) {
////    for i in 1..<inp {
////        if inp % i == 0 {
////           print("\(i)는 소인수 입니다. ")
////        }
////    }
//    var cnt = 0 
//    for i in 1..<inp {
//        
//        if inp % i == 0 {
//            cnt += 1
//        }
//    }
//    if cnt == 1 {
//        print("소수입니다. ")
//    } else {
//        print("소수가 아닙니다. ")
//    }
//}

//primeNumber(7)


// gpt: 소수(prime number)를 판별하는 함수에서 몇 가지 개선할 점이 있습니다. 우선, 소수는 1과 자기 자신으로만 나눠지는 수입니다. 현재 함수에서는 1부터 inp - 1까지의 수로 나누어지는지를 체크하고 있습니다. 하지만 이는 비효율적입니다. 실제로는 inp의 제곱근까지만 검사하면 충분합니다. 또한, 함수는 입력값이 2일 때도 소수로 제대로 판별되지 않습니다.
//func primeNumber2(_ inp: Int) {
//    if inp <= 1 {
//        print("소수가 아닙니다.")
//        return
//    }
//    
//    for i in 2...Int(Double(inp).squareRoot()) {
//        if inp % i == 0 {
//            print("소수가 아닙니다.")
//            return
//        }
//    }
//    
//    print("소수입니다.")
//}

// 소수: 1과 자기자신으로만 나누어 떨어질 수 있는 수
// string은 인덱스로 정수 타입을 사용하지 않고 string.indexfmf tkdydgksek
//func randString(_ inp: String) -> String {
//    var randIdx = inp.index(inp.startIndex, offsetBy: Int.random(in: 0..<inp.count))
//    return String(inp[randIdx])
//}

// print(randString("안녕하세요"))


// 연습문제 2
// 동영상 정답
// 소수: primeNumber: 1과 자기자신만으로 나누어 떨어지는 1보다 큰 양의 정수
// ex) 2, 3, 5, 7, 11
// 97은 1과 자기자신만 97로만 나누어 지므로 소수이다
// 소수 여부를 알려주는 함수
func myPrimeNumber(num: Int) -> Bool {
    if num <= 1 { return false }
        
    for i in 2..<num {
        if num % i == 0 {
            return false
        }
    }
    return true
}

if myPrimeNumber(num: 2) {
    print("소수입니다")
} else {
    print("소수가 아닙니다")
}


// 연습문제3 팩토리얼 함수 만들기
@discardableResult
func factorial(_ num: Int) -> Int {
    var res = 1
    for i in 1...num {
        res *= i
    }
    return res
}
print(factorial(5))


// 팩토리얼 재귀함수 버전
// 자기자신을 반복해서 호출하는 함수
@discardableResult
func factorialRecv(_ num: Int) -> Int {
    if num <= 1 {
        return 1
    }
    return num * factorialRecv(num - 1)
}
print(factorialRecv(5))
