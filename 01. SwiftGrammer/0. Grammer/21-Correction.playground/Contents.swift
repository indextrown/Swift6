/*
 
 (46강) 스위프트 컬렉션 기본 개념 / 배열

 컬렉션
 - 데이터 바구니(=컬렉션)
 - 데이터를 효율적으로 관리하기 위한 자료형(타입)
 - Array, Dictionary, Set


 컬렉션(3가지)
 - Array(배열): 데이터를 순서대로 저장하는 컬렉션
 - Dictionary: 데이터를 키와 값으로 하나의 쌍으로 만들어 관리 하는 순서가 없는 컬렉션
 - set(집합)  : 수학에서 집합과 비슷한 연산을 제공하는, 순서가 없는 컬렉션
 
 
 배열
 - 데이터를 순서대로 저장하는 컬렉션
 - 순서 = 순번 = index
 - 대괄호로 묶음, 각각의 데이터는 요소(element) 라고 지칭
 - 배열의 인덱스는 0부터 자동으로 순서가 지정됨
 - 하나의 배열에는 동일한 타입의 데이터만 담을 수 있다
 - 순서가 있기 때문에 값은 중복 가능하다
 
 리터럴
 - 타입에 해당하는 값을 그대로 사용하는 것
 - 3.5 = double 리터럴
 
*/


var numArray: [Int] = [1, 2, 3, 4, 5]

var numArray1 = [20, 2, 7, 4, 5, 7]

var stringArray: [String] = ["Apple", "Swift", "iOS", "Hello"]


// 배열의 타입 표기
// 배열 = 데이터 바구니
// 정식 문법
let strArray1: Array<Int> = []

// 단축 문법
let strArray2: [String] = []

// 1. 빈 배열의 생성: 항상 타입 써줘야함
let emptyArray1: [Int] = []

// 2. 소괄호 생성 가능 소괄호는 함수의 실행과 관련
let emptyArray2 = Array<Int>()  // 생성자라는 특별한 함수 의미
    
// 3. 단축문법  // 생성자
let emptyArray3 = [Int]()

// 배열의 개수 세기
numArray.count

// 비어있는지 확인
numArray.isEmpty

// num을 포함하는지 확인
numArray.contains(5)

// 배열에서 랜덤으로 하나 추출
numArray.randomElement()

// 해당 인덱스의 요소 순서 바꿈
print(numArray)
numArray.swapAt(0, 1)
print(numArray)

// 배열 각 요소 접근 = 서브스크립트 문법
stringArray[0]
stringArray[1]
stringArray[2]
stringArray[3]

print(stringArray)
stringArray[1] = "steve"
print(stringArray)

// optional
stringArray.first
stringArray.last
print(stringArray.first)

// 배열의 시작 인덱스
stringArray.startIndex  // 항상 0이 나옴
stringArray.endIndex    // ["Apple", "steve", "iOS", "Hello"] -> 4가 나옴

// endIndex: 배열로 저장되는 메모리 공간의 끝을 의미
stringArray[stringArray.endIndex - 1]

// 주로 사용 ex) 서버데이터
// 0이라는 인덱스부터 2만큼 떨어져있음
stringArray.index(0, offsetBy: 2)

// 1부터 2만큼 떨어진 3
stringArray.index(1, offsetBy: 2)

// 처음부터/뒤에서부터 몇번쨰인지
// 배열 요소가 중복일 때 주로 사용함
stringArray.firstIndex(of: "iOS")
stringArray.lastIndex(of: "iOS")

// 주로 사용

if let index = stringArray.firstIndex(of: "iOS") {
    print(index)
    stringArray[index]
}
