//
//  NotificationService.swift
//  VoiceMemo
//
//  Created by 김동현 on 1/10/25.
//

import UserNotifications

struct NotificationService {
    func sendNotification() {
        // requestAuthorization로 인증 확인 
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "타이머 종료!"
                content.body = "설정한 타이머가 종료되었습니다."
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
            }
            // else이면 시스템 설정 알림까지 갈 수 있도록 적용해도됨
        }
    }
}

// MARK: - Notification Delegate를 추가해서 실제로 보내고 컴플리션 핸들러를 받아야한다(Notification이 떴을 때)
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) 
    {
        completionHandler([.banner, .sound])
    }
}
