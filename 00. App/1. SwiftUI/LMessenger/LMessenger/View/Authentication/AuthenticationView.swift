//
//  AuthenticationView.swift
//  LMessenger
//
//  Created by 김동현 on 6/20/25.
//

import SwiftUI

struct AuthenticationView: View {
    
    /// viewModel 을 init 하는 시점은 이 뷰를 만들때로 하자
    @StateObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            switch authViewModel.authState {
            case .unauthenticated:
                LoginIntroView()
                    .environmentObject(authViewModel)
            case .authenticated:
                MainTabView()
                    .environmentObject(authViewModel)
            }
        }
        .onAppear {
            authViewModel.send(action: .checkAuthenticationState)
//             authViewModel.send(action: .logout)
        }
    }
}

#Preview {
    AuthenticationView(authViewModel: AuthenticationViewModel(container: .init(services: Services())))
}
