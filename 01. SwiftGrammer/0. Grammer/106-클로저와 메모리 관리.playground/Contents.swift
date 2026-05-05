/*
 
 (158강)
 클래스에서 
 강한 참조 싸이클로 인한 메모리 누수 -> weak, unknowed키워드로 해결 가능하다
 
 클로저에서
 어떻게 강한 참조 사이클을 해결할끼? -> 결론은 동일
 weak, unknowed키워드로 해결한다
 
 이번 주제
 클로저에서 어떻게 약한참조, 비소유참조 선언하는가?
 
 클로저의 메모리 관리(18단원 7)
 캡처리스트
 
 
 */


func calculateFunc(number: Int) -> Int {
    var sum = 0
    
    func square(num: Int) -> Int {
        sum += (num * num)
        return sum
    }
    let result = square(num: number)
    return result
}
calculateFunc(number: 10)
calculateFunc(number: 20)
calculateFunc(number: 30)




// 결과값 리턴이 아니라 함수를 리턴
func calculateFunc() -> ((Int) -> Int) {
    var sum = 0
    
    func square(num: Int) -> Int {
        sum += (num * num)
        return sum
    }
    // 함수를 리턴
    return square
}


/*
 함수를 변수에 담으면 클로저와 동일한 현상이 발생한다 == 함수에서 필요한 외부변수(sum)을 사용하는 경우
 외부변수를 필연적으로 캡쳐를 해둬야한다
 
 이유
 - calculateFunc()라는 스택프레임을 벗어나더라도 square()는 계속 sum을 사용해야 하기 때문이다
 - 그래서 sum이라는 변수를 캡처하는 현상 발생
 
 */
var squareFunc = calculateFunc()

// 함수를 변수에 담으면 클로저와 동일한 현상 발생
// 클로저의 캡처 현상 또는 함수를 변수에 담았을 때 필요한 외부변수를 담아두는 캡처현상
squareFunc(10)      // 100
squareFunc(20)      // 500
squareFunc(30)      // 1400





// 캡처리스트


/*
 
 1) 파라미터가 없는 경우
 {
     [캡처리스트] in
 }
 
 2) 파라미터가 있는 경우
 {
     [캡처리스트] (파라미터) -> 리턴형 in
 }
 
 */
var num = 1

//let valueCaptureClosure = {
//    print("벨류값 출력(캡처): \(num)")
//}
//
//num = 7
//valueCaptureClosure()
//
//
//num = 1
//valueCaptureClosure()

let valueCaptureClosure2 = { [num] in
    print("벨류값 출력(캡처): \(num)")
}

num = 7
valueCaptureClosure2()  // 1
