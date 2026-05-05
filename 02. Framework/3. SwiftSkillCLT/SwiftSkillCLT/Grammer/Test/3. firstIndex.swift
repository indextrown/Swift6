//
//  firstIndex.swift
//  SwiftSkillCLT
//
//  Created by 김동현 on 1/15/25.
//

// MARK: - 1
let arr: [String] = ["인덱스", "홍길동", "Test"]

// MARK: - 2
struct UserInfo {
    let name: String
    let phone: String
}
let myArr: [UserInfo] = [
    UserInfo(name: "인덱스", phone: "123"),
    UserInfo(name: "홍길동", phone: "000")
]

@main
struct Main {
    static func main() {
        
        // MARK: - 1
        if let firstIndex = arr.firstIndex(of: "홍길동") {
            print(firstIndex)   // 조회해서 첫번째 일치하는 값의 index 반환
        }
        
        // MARK: - 2
        if let index = myArr.firstIndex(where: { $0.phone == "000" }) {
            print(myArr[index].phone)
        }
        
    }
}

/*
 결과
 1
 000
 */
