//
//  AppDelegate.swift
//  VoiceMemo
//
//  Created by 김동현 on 12/24/24.
//

import UIKit

// 앱에서 일어나는 상호작용, 시스템 low level 컨트롤 가능
class AppDelegate: NSObject, UIApplicationDelegate {
    var notificationDelegate = NotificationDelegate()
    
    func application(
        _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // 런칭이 완료된다면
        UNUserNotificationCenter.current().delegate = notificationDelegate
        return true
    }
}
