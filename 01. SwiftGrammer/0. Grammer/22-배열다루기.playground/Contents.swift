/*
 
 (47강) 배열 다루기
 
 
 
 */


/* 삽입하기 */
var alphabet = ["A", "B", "C", "D", "E", "F", "g"]

// 열 또는 중간에 삽입하기
alphabet.insert("H", at: 7)
//print(alphabet)

// 컬렉션을 삽입
alphabet.insert(contentsOf: ["J", "K"], at: 8)
//print(alphabet)


/* 고체하기 */
// 요소 교체하기
// 서브스크립트 문법
alphabet = ["A", "B", "C", "D", "E", "F", "g"]
alphabet[0] = "a"

// 범위로 교체하기
alphabet[0...2] = ["x", "y", "z"]

// 원하는 범위 삭제
alphabet[0...1] = []
//print(alphabet)

// 교체하기 함수 문법   0부터 2까지 컬렉션으로 교체하겠다, 범유ㅣ로 교체하기랑 같은 문법
// 정식적인 함수 문법
alphabet.replaceSubrange(0...2, with: ["a", "b", "c"])


/* 추가하기 */  // 마지막 끝에 추가한다
alphabet = ["A", "B", "C", "D", "E", "F", "g"]
alphabet += ["H"]
alphabet.append("I")
// alphabet.append(1)   문자열 배열에서 정수 넣기 불가
print(alphabet)


/* 삭제하기 */
alphabet = ["A", "B", "C", "D", "E", "F", "g"]

// 서브스크립트 문법으로 삭제
alphabet[0...2] = []

// 요소 한개 삭제
alphabet.remove(at: 2)  // 두번째 자리에 있는 요소를 삭제

// 요소 범위 삭제: 범위에 있는 요소 다 삭제
alphabet.removeSubrange(0...2)
print(alphabet)

// 배열 비어있을 때 사용하면 err 발생
// err: alphabet.removeFirst()  // 맨 앞에 요소 삭제하고 삭제된 요소 리턴(리턴값 String)
alphabet.removeFirst(2) // 앞의 두개의 요소 삭제 => 리턴은 안함
alphabet.removeLast()   // 맨 뒤에 요소 삭제하고 삭제된 요소 리턴(리턴값 String)
alphabet.removeLast(2)  // 뒤에 2개 지움

// 배열 요소 모두 삭제
alphabet.removeAll() // 메모리 공간을 아예 다 없앰 기본값 false인듯?

// 저장공간을 일단은 보관해 둠(안의 데이터만 일단 날림)
// 내용은 지우되 메모리 공간은 유지하겠다
// false하면 메모리 공간을 아예 없앰
alphabet.removeAll(keepingCapacity: true)


