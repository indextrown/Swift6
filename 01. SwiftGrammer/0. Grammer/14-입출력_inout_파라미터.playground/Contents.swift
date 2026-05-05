/*
 
 (38강) 입출력(inout) 파라미터
 - 지금까지 함수의 파라미터는 기본적으로 값타입이고 복사되어 전달한다
 - 파라미터는 임시상수이기 때문에 변경 불가 원칙 

 inout
 - 함수 내에서 변수를 직접 수정하도록 돕는 inout키워드(참조로 전달)
 - 참조를 전달한다 = 메모리의 주소를 전달한다
 - 참조 = 메모리주소
 - 선언시 inout, 실행시 & 사용
 - 내부적으로는 copy in copy out
 - 실제로는 값을 복사했다가 값을 밖으로 빼낼 때 다시 복사해서 가져오는 개념

 주의점
 - 상수로 선언된 변수나 리터럴을 전달하는 것은 불가능하다
 - swapNumbers(a: &123, b: &456)   // 리터럴 불가능-> 메모리 주소를 전달해야 하기 때문
 - inout키워드 사용 시 기본값 설정 불가능
 - 가변 파라미터도 불가능
 
 */


var num1 = 123
var num2 = 456

// 오류발생
func swap(a: Int, b: Int) {
//    var temp = a
//    a = b
//    b = temp
}
//swap(a: num1, b: num2)


// 함수 내에서 변수를 직접 수정하도록 돕는 inout키워드(참조로 전달)
func swapNumbers(a: inout Int, b: inout Int) {  // let a로 선언되는게 아니라 기존의 num1을 전달받을 때 값복사가 아닌 num1 자체의 주소값이 전달된다
    var temp = a
    a = b       // 여기서 a는 실제의 num1이라고 생각
    b = temp
}
swapNumbers(a: &num1, b: &num2) // &(엠퍼센트 기호)

// swapNumbers(a: &123, b: &456)   // 불가능-> 메모리 주소를 전달해야 하기 때문


