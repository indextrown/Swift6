//
//  LMessengerApp.swift
//  LMessenger
//
//  Created by 김동현 on 6/20/25.
//

import SwiftUI

/// 앱 시작점
@main
struct LMessengerApp: App {
    
    // MARK: - Firebase 초기화코드는 UIKit LifeCycle를 사용한다.
    /// UIApplicationDelegateAdaptor이 UIKit LifeCycle를 사용하도록 해주는 프로퍼티 래퍼이다.
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // MARK: - StateObject는 View 내부에서 ViewModel을 직접 생성시 사용하는 속성 래퍼다
    @StateObject private var container: DIContainer = DIContainer(services: Services())
    
    var body: some Scene {
        WindowGroup {
            
            // MARK: - 매개변수로 넘기는 것
            /// viewModel생성에 사용한다.
            /// view.viewModel 테스트시 원하는 형태 주입 가능
            /// viewModel 내부에서 container 이용하기 위함
            AuthenticationView(authViewModel: AuthenticationViewModel(container: container))
            
            // MARK: - 여러 하위 View에서 공유해서 사용
                .environmentObject(container)
        }
    }
}


/*
@main
struct LMessengerApp: App {
    
    /// sceneDelegate가 담당했던 lifeCycle을 windowGroup의 onChange modifier를 사용하여 scenePhase에 대한 값을 접근할 수 있다
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView()
        }
        .onChange(of: scenePhase) { _, newScenePhase in
            switch newScenePhase {
            case .active:
                break
            case .inactive:
                break
            case .background:
                break
            default:
                break
            }
        }
    }
}
*/
