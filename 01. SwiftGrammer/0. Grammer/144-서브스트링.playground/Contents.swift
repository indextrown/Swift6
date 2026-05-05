/*

 (199강)
 서브스트링
 - 하위의 문자열이다
 
*/

import UIKit

var greeting = "hello, world!"

// ,(콤마) 인덱스를 가져올 수 있다      ?? 없으면(옵셔널이라면) 나오는값이 nil일것이다 이럴 경우 endIndex를 기본값으로 설정하겠단
let index: String.Index = greeting.firstIndex(of: ",") ?? greeting.endIndex // endIndex는 문자열의 특별한 String.Index 타입으로 나온다

// greeting에 접근해서 서브스크립트를 이용해서 얻어낼 수 있다
// ,중심으로 앞에있는 것을 얻어낼 수 있다
let beginning: String.SubSequence = greeting[..<index]
print(beginning) // hello
 

// String.SubSequence타입의 개념: 실제로 메모리공간을 공유하겠다는 개념이다

// 메모리를 공유하는 어떤 개념이 있는데 그 개념이 서브스트링이구나...



// prefix: 접두어(앞에 있는 글자). 즉 앞에서 5글자 뽑아내겠다
// MARK: 서브스트링으로 저장된다 = 새로운 메모리 공간을 만들지 않고 기존의 greeting 메모리 공간을 공유하고 있다
var word: String.SubSequence = greeting.prefix(5)

// MARK: 문자열은 결국 메모리 공간을 차지하고 있는데 새로운 메모리 공간을 사용하지 않고 스위프트 내부적으로 잘 설계되어 메모리 공간이 공유되는 개념이 존재한다는 것이다

greeting = "Happy"
print(word)

