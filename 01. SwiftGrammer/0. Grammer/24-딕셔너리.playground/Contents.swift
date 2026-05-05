/*
 
 (49강) 딕셔너리
 
 딕셔너리
 - 각 데이터를 키와 값으로 하나의 쌍으로 만들어 관리하는 컬렉션
 - key, value로 이루어져 있음
 - key 중복 불가, value 중복 가능
 - key는 동일한 타입이어야함
 - value도 동일한 타입이어야함
 
 딕셔너리는 따로 값만 검색하는 방법은 제공하지 않음, 키값이 중요
 */

//let dic: Dictionary<String, String> = ["A": "Apple", "B": "Banana"]
// 단축문법 [String, String]
// 딕셔너리는 append함수를 제공하지 않음. 가장 마지막 즉 순서가 없음
// remove는 존재


var dic = ["A": "Apple", "B": "Banana", "C": "City"]
var dic1 = [1: "Apple", 2: "Banana", 3: "City"]

// 딕셔너리는 순서가 없다
// 내부적으로 순서가 존재하지 않아서 매번 다르게 출력됨
print(dic)
print(dic1)

// 단축문법
var words: [String: String] = [:]

// 정식문법
var words1: Dictionary<Int, String>

// 빈 딕셔너리 생성
// error: 타입추론 불가 let emptyDic1 = [:]
let emptyDic1: Dictionary<Int, String> = [:]
// 배열과 마찬가지로 생성자 즉 함수 실행으로 빈 딕셔너리 만들 수 있음
let emptyDic2 = Dictionary<Int, String>()
let emptyDic3 = [Int: String]() //


var dictFromLiteral = ["1": 1, "2": 2]
dictFromLiteral = [:]   // 이미 타입을 정의했기때문에 타입 안써도 됨



/* 딕셔너리 기본 기능 */
dic = ["A": "Apple", "B": "Banana", "C": "City"]

dic.count
dic.isEmpty
//dic.contains(where: <#T##(Dictionary<String, String>.Element) throws -> Bool#>)

// Optional Named Tuple로 나옴
if let tuple = dic.randomElement() {
    print(tuple)
}

// 딕셔너리는 기본적으로 서브스크립트[]를 이용한 문법을 주로 사용
dic = ["A": "Apple", "B": "Banana", "C": "City"]

// 서브스크립트 문법은 특별한 함수를 실행하는 방법이다
// 전달하는 자체 "A"가 파라미터 라는 것을 인지하자
// 반환형: Optional String
print(dic["A"]) // 반환값: 문자열이 아닌 옵셔널 문자열

if let value = dic["A"] {
    print(value)
} else {
    print("not found")
}

// 만약 S라는 키값이 없으면 Empty를 반환하겠다 반환형 String
// nil이 나올 확률이 없기 때문에 if let 바인딩 쓸 필요 x
dic["S", default: "Empty"]

// keyS로 리턴
print(dic.keys)
print(dic.values)

print(dic.keys.sorted()) //array로 리턴(배열로 쓰고 싶을 때)
print(dic.values.sorted())


// 서브스크립트 문법
var myWords: [String: String] = [:]
myWords["A"] = "Apple"
myWords["B"] = "Banana"
myWords["C"] = "Blue"
print(myWords)

// update + insert = upsert
// C키값을 가진 Ciry 추가
// nil: 요소가 추가 됬다는 의미-> 새로운 것을 추가하면 기존의 바꿀 것이 없다는 의미 즉 단순하게 추가한다
myWords.updateValue("City", forKey: "C")  // nil
myWords.updateValue("DDD", forKey: "D")  // nil
print(myWords)

myWords = [:]        // 빈 딕셔너리로 만들기
myWords = ["A":"A"]  // 전체 교체하기(바꾸기)


// 요소 삭제하기
myWords["B"] = nil  // 해당요소 삭제
myWords["A"] = nil  // 존재하지 않는 키값을 삭제 --> 아무일도 일어나지 않음(에러아님)
print(myWords)

// 함수로 삭제해보기
dic = ["A": "Apple", "B": "Banana", "C": "City"]
dic.removeAll()
dic.removeAll(keepingCapacity: true)    // 메모리의 공간은 그대로 유지하겠다



