//
//  RPSManager.swift
//  RPSGame
//
//  Created by 김동현 on 2/20/25.
//

import Foundation

struct RPSManager {
    // 데이터 저장을 위한 변수(컴퓨터 선택 / 나의 선택)
    private var comChoice: RPS = RPS(rawValue: Int.random(in: 1...3))!
    private var myChoice: RPS = RPS(rawValue: Int.random(in: 1...3))!
    
    func getReady() -> RPS {
        return RPS.ready
    }
    
    func getUserRps() -> RPS {
        return myChoice
    }
    
    func getComRps() -> RPS {
        return comChoice
    }
    
    mutating func userGetSelected(name: String) {
        switch name {
        case "가위":
            // 가위 열거형을 만들어서 저장
            myChoice = RPS.scissors
        case "바위":
            // 바위 열거형을 만들어서 저장
            myChoice = RPS.rock
        case "보":
            // 보 열거형을 만들어서 저장
            myChoice = RPS.paper
        default:
            myChoice = RPS.rock
        }
    }
    
    func getRpsResult() -> String {
        if comChoice == myChoice {
            return "비겼다"
        } else if comChoice == .rock && myChoice == .paper {
            return "이겼다"
        } else if comChoice == .paper && myChoice == .scissors {
            return "이겼다"
        } else if comChoice == .scissors && myChoice == .rock {
            return "이겼다"
        } else {
            return "졌다"
        }
    }
    
    mutating func allReset() {
        comChoice = RPS(rawValue: Int.random(in: 1...3))!
        myChoice = RPS(rawValue: Int.random(in: 1...3))!
    }
}


