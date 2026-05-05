//
//  Double+Extension.swift
//  VoiceMemo
//
//  Created by 김동현 on 1/8/25.
//

import Foundation

// MARK: - 음성메모에서 몇시 몇분 표현해주기 위해 사용
extension Double {
    // 03:05
    var formattedTimeInterval: String {
        let totalSeconds = Int(self)
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
