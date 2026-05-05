//
//  UpdownManager.swift
//  UpDownGame
//
//  Created by 김동현 on 2/20/25.
//

struct UpdownManager {
    // 컴퓨터가 랜덤으로 숫자 선택
    private var comNumber = Int.random(in: 1...10)
    
    // 내가 선택한 숫자를 담는 변수
    private var myNumber: Int = 1
    
    mutating func resetNum() {
        comNumber = Int.random(in: 1...10)
        myNumber = 1
    }
    
    mutating func setUserNum(num: Int) {
        myNumber = num
    }
    
    func getUpDownResult() -> String {
        if comNumber > myNumber {
            return "Up"
        } else if comNumber < myNumber {
            return "Down"
        } else {
            return "Bingo👍"
        }
    }
}
