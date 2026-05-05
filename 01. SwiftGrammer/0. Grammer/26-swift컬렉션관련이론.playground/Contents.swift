/*
 
 (52강)
 KeyValuePairs
 - 딕셔너리와 유사한 형태이지만 배열처럼 순서가 있는 컬렉션

 */


let introduce: KeyValuePairs = ["first": "hello", "second": "world", "third": "!"]

// 기본기능
introduce.count
introduce.isEmpty

// 요소의 접근
// 배열처럼 인덱스로 접근 가능
// 요소에서는 튜플방식으로 접근
introduce[2].1


introduce[2].key
introduce[2].value

// append, remove 기능 없음


// copy on write 최적화
var array = [1, 2, 3, 4, 5, 6, 7]

// copy on write 최적화 발생
// 값복사이지만 실제로 새로운 메모리 공간을 만들지 않을 수 있음-> 주소만 가리킬 수 있음
var subArray = array[0...2]




 
