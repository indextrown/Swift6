/*
 
 
(48강) 배열 기타
 
 
 */

var nums = [1, 2, 3, 1, 4, 5, 2, 6, 7, 5, 0]

// 배열 자체를 정렬
nums.sort()

// 배열 자체를 변경시키지는 않고 새로운 배열을 리턴
nums.sorted()

nums.reverse()
nums.reversed()

nums = [1, 2, 3, 1, 4, 5, 2, 6, 7, 5, 0]

// 쓸수도있다
nums.sorted().reversed()

// 배열 랜덤으로 섞기
nums.shuffle()
nums.shuffled()


/* 배열의 비교 */

let a = ["A", "B", "C"]
let b = ["A", "B", "C"]
a == b
a != b


/* 활용 */
var puppy1 = ["p", "u", "p", "p", "y"]

// 뒤에서부터 처음 나오는 P 가 몇번쨰 요소인지
if let lastIndexOfP = puppy1.lastIndex(of: "p") {
    puppy1.remove(at: lastIndexOfP)
}

print(puppy1)

if !nums.isEmpty {
    print("\(nums.count) element(s)")
} else {
    print("empty array")
}

/* 배열의 중첩 */
var data = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
print(data[0][2])
print()

/* 반복문과의 결합 */
for i in nums {
    print(i)
}


// enumerated: 열거하다, 하나씩 나열하다
for tuple in nums.enumerated() {
    //print(tuple)    // named tuple 형식으로 전달
    print("\(tuple.0) - \(tuple.1)")
}

for (index, word) in nums.enumerated() {
    print("\(index) - \(word)")
}

nums = [10, 11, 12, 13, 14]

for (index, value) in nums.enumerated().reversed() {
    print("\(index) - \(value)")
}

