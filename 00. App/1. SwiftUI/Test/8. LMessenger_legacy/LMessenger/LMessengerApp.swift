//
//  LMessengerApp.swift
//  LMessenger
//
//  Created by 김동현 on 10/29/24.
//

import SwiftUI

@main
struct LMessengerApp: App {
    // 파이어베이스 초기화
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // environmentObject로 주입하기 위해 StateObject 사용
    // MARK: - 의존성
    @StateObject var container: DIContainer = .init(services: Services())
    
    var body: some Scene {
        WindowGroup {
            // stateobject or observedobject를 매개변수??
            AuthenticatedView(authViewModel: .init(container: container))
                .environmentObject(container)
        }
    }
}

