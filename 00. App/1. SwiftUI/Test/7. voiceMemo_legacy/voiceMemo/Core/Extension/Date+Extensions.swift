//
//  Date+Extensions.swift
//  voiceMemo
//

import Foundation

extension Date {
    // MARK: - 오전/오후 시:분 형식으로 변환하는 속성
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")  // 한국
        formatter.dateFormat = "a hh:mm"  // 오전오후 몇시:몇분
        return formatter.string(from: self) // 현재 들어온 데이터값을 반환
    }
    
    // MARK: - 날짜 포맷을 "오늘" 또는 "M월 d일 E요일" 형식으로 변환하는 속성
    var formattedDay: String {
        let now = Date()
        let calender = Calendar.current     // 현재 날짜와 시간 가져옴
        
        let nowStartOfDay = calender.startOfDay(for: now)   // 오늘 날짜의 시작 시각(00:00:00)을 가져옴
        let dateStartDay = calender.startOfDay(for: self)   // 입력된 날짜(self)의 시작 시각(00:00:00)을 가져옴
        
        // 현재 날짜와 입력된 날짜 사이의 일 수 차이를 계산
        let numOfDaysDifference = calender.dateComponents([.day], from: nowStartOfDay, to: dateStartDay).day!
        
        // 날짜 차이가 0이면 오늘이므로 "오늘" 반환
        if numOfDaysDifference == 0 {
            return "오늘"
        } else {
            // 날짜 차이가 있으면 "M월 d일 E요일" 형식으로 반환
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "M월 d일 E요일"
            return formatter.string(from: self)
        }
    }
}

/*
 MARK: - 사용법
 
 let now = Date()  // 현재 날짜와 시간을 가져옴

 // 현재 시간을 "오전/오후 시:분" 형식으로 출력
 let timeString = now.formattedTime
 // 현재 날짜를 "오늘" 또는 "M월 d일 E요일" 형식으로 출력
 let dayString = now.formattedDay
 
 // 출력 예시
 print("현재 시간: \(timeString)")  // 예: "현재 시간: 오후 02:30"
 print("오늘 날짜: \(dayString)")   // 예: "오늘 날짜: 오늘"

 // 과거 날짜(예: 어제 날짜)를 사용한 출력 예시
 let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)!
 let yesterdayString = yesterday.formattedDay
 print("어제 날짜: \(yesterdayString)")  // 예: "어제 날짜: 10월 11일 금요일"
 
 */
