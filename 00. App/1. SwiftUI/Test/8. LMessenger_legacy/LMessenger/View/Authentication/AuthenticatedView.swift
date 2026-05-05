//
//  AuthenticatedView.swift
//  LMessenger
//
//  Created by 김동현 on 10/29/24.
//

import SwiftUI

struct AuthenticatedView: View {
    
    // viewModel을 init하는 시점은 이 view를 만들때로 진행
    // viewModel에서 Container를 init할 때 주입해줄 예정이기 때문
    @StateObject var authViewModel: AuthenticationViewModel
    var body: some View {
        VStack {
            switch authViewModel.authenticationState {
            case .unauthenticated:
                // TODO: loginView
                LoginIntroView()
                    .environmentObject(authViewModel)
                // 부모 뷰에서 특정 데이터가 하위 뷰들 전체에 공유되어야 할 때 사용
                // authViewModel을 LoginIntroView나 그 하위 뷰들이 모두 사용해야 할경우 전달
            case .authenticated:
                // TODO: MainTabView
                MainTabView()
                    .environmentObject(authViewModel)
            }
        }
        .onAppear {
            authViewModel.send(action: .checkAuthenticationState)
//            authViewModel.send(action: .logout)
        }
    }
}

#Preview {
    // 이 부분에서 .init()은 AuthenticationViewModel을 새로 만드세요라는 의미입니다.
    AuthenticatedView(authViewModel: .init(container: .init(services: StubService())))
}

