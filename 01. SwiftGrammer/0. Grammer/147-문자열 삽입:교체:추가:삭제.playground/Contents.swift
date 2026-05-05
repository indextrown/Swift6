import UIKit

// 문자열의 삽입/교체/추가/삭제

// MARK: - 삽입하기
var welcome = "Hello"

welcome.insert("w", at: welcome.index(after: welcome.startIndex))
welcome.insert(contentsOf: "www", at: welcome.index(after: welcome.startIndex))
welcome.insert("!", at: welcome.endIndex)



welcome = "Hello there!"

// MARK: - 교체하기(replace)    // 인덱스를 뽑아냄
if let range = welcome.range(of: " there!") {       // 범위를 가지고
    welcome.replaceSubrange(range, with: " Swift!") // 교체하기
    print(welcome)
}

// 교체하되, 문자열 원본은 그대로(occurrence: 존재하는)
var newWelcome = welcome.replacingOccurrences(of: "Swift", with: "World") // Swift가 있으면 World로 교체하겠다

print(welcome)
print(newWelcome)
                                                            // 대소문자 무시 옵션
welcome.replacingOccurrences(of: "swift", with: "New World", options: [.caseInsensitive], range: nil)

print(welcome)
print(newWelcome)

// MARK: - 추가하기(append)   데이터 바구니라서 가능
welcome += "?"
welcome.append("!")

// MARK: - 삭제(제거)하기 (remove)
welcome.remove(at: welcome.index(before: welcome.endIndex)) // ! 지우기
welcome


// 인덱스 범위파아
var range = welcome.index(welcome.endIndex, offsetBy: -6)..<welcome.endIndex

welcome.removeSubrange(range)
welcome.removeAll()
welcome.removeAll(keepingCapacity: true)    // 메모리 용량을 남겨두겠다

// 
