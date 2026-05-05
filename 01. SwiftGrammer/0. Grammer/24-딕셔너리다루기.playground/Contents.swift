/*
 
 (50강)
 딕셔너리
 - 딕셔너리는 열거하지 않아도 Named튜플 형태로 하나씩 꺼내서 전달
 - 순서가 없으므로 실행마다 순서가 달라짐
 - 데이터 바구니이기 때문에, 차례대로 꺼내서 사용하는 경우가 많을 수 있음
 
 */

let a = ["A": "Apple", "B": "Banana", "C": "City"]
let b = ["A": "Apple", "B": "Banana", "C": "City"]

// 딕셔너리는 순서 상관없음, 비교 가능
a == b

// 딕셔너리의 value에 배열이 들어갈 수 있다
var dict1 = [String: [String]]()
dict1["arr1"] = ["A", "B", "C"]
dict1["arr2"] = ["D", "E", "F"]
print(dict1)

let dict = ["A": "Apple", "B": "Banana", "C": "City"]

// 매번 랜덤값
// Swift에서 가장 잘 다룰 수 있는 타입 = 튜플

for item in dict {
    print("\(item.key): \(item.value)")
}
for (key, value) in dict {
    print("\(key): \(value)")
}

for (key, _) in dict {
    print("Key: ", key)
}

for (_, value) in dict {
    print("Value: ", value)
}
