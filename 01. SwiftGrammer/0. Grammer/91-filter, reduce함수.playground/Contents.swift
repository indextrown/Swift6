import UIKit

/*
 (151강)
 filter함수
 - 필터링을한다~
 - filter 함수는 파라미터로 함수를 사용하고있다
 - 함수부분이 클로저뿐만아니라 함수도 가능하다
 - 함수 = 클로저 같은거다
 - True가 나오는 녀석들만 뽑아서 새로운 배열을 만들어서 리턴을 해준다
 
 
 
 map
 - 배열에 있는 녀석들을 하나하나 꺼내서 원하는 타입으로 변환(매핑)해준다
 
 filter
 - 참/거짓을 판단해서 참인경우를 뽑아낸다
 
 reduce
 - 여러개의 아이템을 제거해서 하나의 result값으로 만들겠다는것이다
 - reduce함수는 초기값과 클로저가 필요하다
 
 
 
 for문으로 구현하기에 복잡한 기능을 고차함수로 간단하게 구현 가능하다
 
 */


// containes: 문자열에 구현되어있음, Argument(인자) 받는 문자를 포함하면 true 리턴
"Black".contains("B")   // true
"Black".contains("b")   // false


let names = ["Apple", "Black", "Circle", "Dream", "Blue"]
// names.filter(<#T##isIncluded: (String) throws -> Bool##(String) throws -> Bool#>)
// 문자열을 input으로 가지고 output으로 bool타입을 가지는 클로저를 가지는 고차함수 filter

// 배열에서 B를 포함하고 있는 녀석들만 꺼내서 aaa에 담고 출력해라
var aaa = names.filter { str in
    // 참과 거짓을 판단하는 논리 구현부분, 대분자 B를 포함하는 녀석들은 참이 나오는데
    // 참이 나오는 아이템들을 필터링해서 다시 뽑아서 배열로 저장하겠다 라는 의미
    return str.contains("B")
}
print(aaa)






let array = [1, 2, 3, 4, 5, 6, 7 ,8]
// 타입추론으로 알수있어서 생략해서 num으로 작성가능
var enevNumberArray = array.filter { num in
    return num % 2 == 0
}

// 참고
var enevNumberArray2 = array.filter { (num) -> Bool in
    return num % 2 == 0
}

// 클로저는 파라미터 생략해도되고
var enevNumberArray3 = array.filter {
    return $0 % 2 == 0
}

// 한줄인경우 리턴해도된다 하지만 첫번쨰 파라미터는 $0으로 써야한다
var enevNumberArray4 = array.filter {
    $0 % 2 == 0
}


print(enevNumberArray)
//print(enevNumberArray2)
//print(enevNumberArray3)
//print(enevNumberArray4)



// 굳이 클로저로 안해도 된다 하지만 보통 클로저를 사용한다
// 코드가 너무 길어서 짧은 클로저를 사용한다
func isEven(_ num: Int) -> Bool {
    return num % 2 == 0
}

var bbb = array.filter(isEven)
//print(bbb)



// 필터링 두번 적용 가능하다
// 필터링 결과도 배열이라서 가능
// 짝수만 가져오고 5보다 작은것만 가져온다
enevNumberArray = array.filter { $0 % 2 == 0 }.filter { $0 < 5 }
//print(enevNumberArray)









// reduce함수도 배열에서 사용한다
// 파라미터 2개를 요구하는데 뒤에꺼는 함수형타입이다
var numbersArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
// numbersArray.reduce(<#T##initialResult: Result##Result#>, <#T##nextPartialResult: (Result, Int) throws -> Result##(Result, Int) throws -> Result##(_ partialResult: Result, Int) throws -> Result#>)

var aaaa = numbersArray.reduce(0) { a, b in
    return a + b
}

print(aaaa) // 55

// redice함수는 누적적으로 무언가를 한다, 그래서 초기값이 필요하다
// 0이라는 값을 뽑아서 a에 넣는다, b에는 배열의 첫번째 요소 1을 넣는다. --> 0+1을해서 return해서 더한 값이 그다음 초기값으로 쓰인다
// 1이 a로 들어가고 다음숫자인 2를 b에 넣는다 1+2를 retuen해서 초기값에 넣는다
// ...



var resultSum = numbersArray.reduce(0) { (sum, num) in
    return sum + num
}

print(resultSum)

// 100에서 하나씩 뺀다 즉 100 - 55 = 45
resultSum = numbersArray.reduce(100) { $0 - $1 }
print(resultSum)

// 0 + 1
// 01 + 2
// 012 + 3
// 0123 +. ...
//
var aaaaa = numbersArray.reduce("0") { result, item in
    return result + String(item)
}

print(aaaaa)















// map / filter / reduce 활용
numbersArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// 위의 배열 중에, 홀수만 제곱해서, 그 숫자를 다 더한 값은?
var result = numbersArray.filter { $0 % 2 != 0 }.map { $0 * $0 }.reduce(0) {$0 + $1}
print(result)


// 같음
var result2 = numbersArray.filter { num in
    return num % 2 != 0
}.map {num in
    return num * num
}.reduce(0) { first, item in
    return first + item
}
print(result2)



