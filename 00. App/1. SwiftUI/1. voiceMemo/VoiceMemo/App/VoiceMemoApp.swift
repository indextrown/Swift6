//
//  VoiceMemoApp.swift
//  VoiceMemo
//
//  Created by 김동현 on 12/24/24.
//

import SwiftUI

@main
struct VoiceMemoApp: App {
    
    // 필요한 이유: 앱 구조체가 UiKit기능이나 low level의 ios 시스템 이벤트를 처리하기 위해(이 프로젝트에서는 Notificationdelegate)
    // swiftui에서는 UIApplicationDelegateAdaptor를 통해 uikit와 상호작용 가능
    // swiftui의 라이프사이클을 사용하는 앱에서 appdelegate 콜백을 처리하려면 UIApplicationDelegate프로토콜을 준수하여야하고 각자 필요한 delegate 메서드를 구현해야 한다
    // 프로퍼티 래퍼로 delegate 선언
    // swiftui는 delegate를 인스턴스화하고 생명주기 이벤트가 발생할 때 마다 응답해서 delegate 메서드를 호출한다
    // 앱에서 한번만 선언해야한다(그렇지 않으면 런타임 에러 발생)
    
    // 프로퍼티 래퍼
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}
