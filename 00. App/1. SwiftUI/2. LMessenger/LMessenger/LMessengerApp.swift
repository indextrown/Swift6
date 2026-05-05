//
//  LMessengerApp.swift
//  LMessenger
//
//  Created by 김동현 on 1/13/25.
//

import SwiftUI

@main
struct LMessengerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate 
    @StateObject private var container: DIContainer = .init(services: Services())
    
    var body: some Scene {
        WindowGroup {
            // MARK: - View를 init할 때 viewModel을 생성하고 있기에 컨테이너도 여기에 주입
            // container를 직접 전달하여, AuthenticationViewModel이 필요한 서비스(authService 등)를 컨테이너에서 가져올 수 있도록 설정
            // 명시적 의존성 주입: AuthenticationViewModel이 container에 명확하게 의존하고 있음을 코드에서 알 수 있습니다.
            // 테스트 가능성 증가: 주입되는 container를 테스트용 Mock 객체로 쉽게 대체할 수 있습니다.
            AuthenticatedView(authViewModel: AuthenticationViewModel(container: container))
                .environmentObject(container)
            // SwiftUI의 뷰 계층 전체에서 container를 공유하고, 필요한 하위 뷰들이 쉽게 접근할 수 있도록 설정합니다.
            // 예를 들어, AuthenticatedView의 하위 뷰가 컨테이너를 직접 사용해야 할 경우, 매번 매개변수로 전달하지 않아도 됩니다.
        }
        
    }
}
