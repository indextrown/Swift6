import UIKit

/*
 
 (200강)
 문자열 다루기
 
 
 잠시 배열 복습
 - 배열에서 인덱스를 배웠다
 
 */


// 문자열 = 데이터바구니와 비슷한 개념이다
// 배열은 눈에 보이는 데이터 바구니(쉽게 변경 가능

var someString = "Swift"

// 문자를 문자열(String) 배열화 하기
// 하나하나 뽑아서 새로운 타입으로 변환하겠다
// someString을 배열로 변형할 수 있다

// MARK: 1)
var array = someString.map { String($0) }

// 2)
var array2 = someString.map { chr in // 문자를 문자열로 변형시키는 것이다
    String(chr)
}
print(array)
print(array2)


// 3) 배열을 생성하는 생성자(Character배열)  ==> 문자배열은 잘 안씀
var array3: [Character] = Array(someString)
var array4: [String.Element] = Array(someString)

// 4) 문자열배열(참고용)
var array5: [String] = Array(arrayLiteral: someString)


// 5) MARK: 문자열 배열 ===> 문자열로만들기
array.joined() // 전부 합쳐서 문자열로 만들어줌

// 6) 문자 배열 ===> 문자열로 만들기(스트링생성자에 문자배열을 넣어준다)
var newString2 = String(array3)



// MARK: 코딩테스트 활용
someString = "Swift"
//someString.randomElement()  // 문자열에서 랜덤으로 뽑아내는 것 가능
//someString.shuffled()       // 문자열을 섞어서 문자(Character)배열로 리턴

var newString3 = String(someString.shuffled())
print(newString3 )

// map고차함수를 사용해서 변환
newString3 = someString.map { String($0) }.shuffled().joined()
print(newString3)

