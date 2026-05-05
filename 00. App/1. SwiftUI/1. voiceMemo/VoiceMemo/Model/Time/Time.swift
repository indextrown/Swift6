//
//  Time.swift
//  VoiceMemo
//
//  Created by 김동현 on 1/9/25.
//

import Foundation

struct Time {
    var hours: Int
    var minutes: Int
    var seconds: Int
    
    // 초 단위로 변환
    var convertedSeconds: Int {
        return (hours * 3600) + (minutes * 60) + seconds
    }
    
    // 초를 시간, 분, 초로 변환
    // Time.fromSeconds()로 접근하기 위해
    static func fromSeconds(_ seconds: Int) -> Time {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = (seconds % 3600) % 60
        
        return Time(hours: hours, minutes: minutes, seconds: remainingSeconds)
    }
}

/*
 MARK: - 사용법
 
 let initialTime = Time(hours: 1, minutes: 20, seconds: 40)
 let totalSeconds = initialTime.convertedSeconds
 let newTime = Time.fromSeconds(totalSeconds)

 print("초로 변환된 값: \(totalSeconds)") // 총 초 계산
 print("다시 변환된 값: \(newTime.hours)시간 \(newTime.minutes)분 \(newTime.seconds)초")

*/
