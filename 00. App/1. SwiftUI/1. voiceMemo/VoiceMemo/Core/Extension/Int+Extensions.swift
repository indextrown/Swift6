//
//  Int+Extensions.swift
//  VoiceMemo
//
//  Created by 김동현 on 1/9/25.
//

import Foundation

// MARK: - 타이머 기능을 위해 사용
extension Int {
    var formattedTimeString: String {
        let time = Time.fromSeconds(self)
        let hourString = String(format: "%02d", time.hours)
        let minuteString = String(format: "%02d", time.minutes)
        let secondString = String(format: "%02d", time.seconds)
        
        return "\(hourString) : \(minuteString) : \(secondString)"
    }
    
    // 몇시로 세팅하는지
    var formattedSettingTime: String {
        // 현재시간 받아오기
        let currentDate = Date()
        // 세팅 시간 만들기
        let settingDate = currentDate.addingTimeInterval(TimeInterval(self))
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")          // 한국어로 지역화
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 한국 시간대
        formatter.dateFormat = "HH:mm"                          // 형식으로 시간을 표시
        
        let formattedTime = formatter.string(from: settingDate)
        return formattedTime
    }
}

/*
 MARK: - 사용법
 MARK: - self는 formattedTimeString롤 호출한 Int값을 의미
 let timerValue = 7265 // 7265초
 print(timerValue.formattedTimeString) // 출력: 02 : 01 : 05
 
 
 let secondsToAdd = 3600 // 1시간 (3600초)
 print(secondsToAdd.formattedSettingTime)
 현재 시간이 12:00이라면 -> "13:00"
 */
