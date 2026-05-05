/*
 
 (51강) set
 
 set
 - 수학에서의 집합과 비슷한 연산을 제공하는, 순서가 없는 컬렉션
 - 대괄호로 묶음(배열과 구분이 안되기 때문에) 반드시 타입 선언을 해야함
 - 서브스크립트 관련 문법 존재 x
 - 대괄호[]: 함수 실행의 의미와 비슷함

 */

// 정식문법
var set: Set<Int> = [1, 1, 2, 3]
print(set)


// 단축문법
var set2: Set = [1, 1, 2, 2, 3, 3]
print(set2)

// 빈 et 생성
let emptySet: Set<Int> = []
let emptySet1 =  Set<Int>()

set.count
set.isEmpty

set.contains(1)
set.randomElement()

// set update하기,
// 1요소 추가
set.update(with: 1) // 1 리턴(기존에 있어서)
set.update(with: 7) // nil 리턴(기존에 없어서)
print(set)

var stringSet: Set<String> = ["Apple", "Banana", "Swift"]
stringSet.remove("Swift")   // 삭제한 요소 리턴을 함 리턴: 옵셔널 스트링
print(stringSet)

// 존재하지 않는 요소 삭제해보기
stringSet.remove("test")    // 에러 발생 x

// 전체요소 삭제
stringSet.removeAll()
stringSet.removeAll(keepingCapacity: true)

// set의 활용
var a: Set = [1, 2, 3, 4, 5, 6, 7, 8, 9]
var b: Set = [1, 3, 5, 7, 9]
var c: Set = [2, 4, 6, 8, 0]
var d: Set = [1, 7, 5, 9, 3]

a == b
a != b
b == d

// 부분집합/상위집합/서로소
b.isSubset(of: a)           // true 부분집합 여부
b.isStrictSubset(of: a)     // 엄격한 부분집합이니 = 진부분집합이니 = a랑 동일하지 않으면서 부분집합으로 이루어져 있니?

a.isSuperset(of: b)          // true 상위집합 여부
a.isStrictSuperset(of: b)   // false 진 상위집합 여부

// 서로소 여부
d.isDisjoint(with: c)






// 합집합 union
var unionSet = b.union(c)
print(unionSet)

//b.formUnion(c)  // b 원본을 변경
print(b)

// 교집합 intersection
var interSet = a.intersection(b)

// 차집합 subtracting
var subSet = a.subtracting(b)
// a.subtract(b)   // 원본 변경

// 반복문과의 결합
let iteratingSet: Set = [1, 2, 3]

for num in iteratingSet {
    print(num)
}

// 기타 유의점
var numSet: Set = [1, 2, 3, 4, 5]
var newArray = numSet.sorted()

