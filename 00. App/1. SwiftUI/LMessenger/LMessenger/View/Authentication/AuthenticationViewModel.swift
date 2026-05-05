//
//  AuthenticationViewModel.swift
//  LMessenger
//
//  Created by 김동현 on 6/21/25.
//

import Foundation
import Combine
import AuthenticationServices

enum AuthenticationState {
    case unauthenticated
    case authenticated
}

final class AuthenticationViewModel: ObservableObject {
    
    enum Action {
        case checkAuthenticationState
        case googleLogin
        case appleLogin(ASAuthorizationAppleIDRequest)
        case appleLoginCompletion(Result<ASAuthorization, Error>)
        case logout
    }
    
    @Published var authState: AuthenticationState = .unauthenticated
    @Published var isLoading: Bool = false
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    private var currentNonce: String?
    var userId: String?
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .checkAuthenticationState:
            if let userId = container.services.authService.checkAuthenticationState() {
                self.userId = userId
                self.authState = .authenticated
            }
        case .googleLogin:
            self.isLoading = true
            container.services.authService.signInWIthGoogle()
                .flatMap { user in
                    self.container.services.userService.addUser(user)
                }
                .sink { [weak self] completion in
                    /*
                     퍼블리셔 끝났을 때 호출
                     성공/실패 구분
                     */
                    
                    // 실패
                    if case .failure = completion {
                        self?.isLoading = false
                    }
                } receiveValue: { [weak self] user in
                    /*
                     퍼블리셔가 값을 보낼 때마다 호출
                     */
                    self?.isLoading = false
                    self?.userId = user.id
                    self?.authState = .authenticated
                }.store(in: &subscriptions) /// 구독권 추가
            
        case .appleLogin(let request):
            self.isLoading = true
            let nonce = container.services.authService.handleSignInWithAppleRequest(request)
            self.currentNonce = nonce
            
        case .appleLoginCompletion(let result):
            if case let .success(authorization) = result {
                guard let nonce = currentNonce else { return }
                container.services.authService.handleSignInWIthAppleCompletion(authorization, nonce: nonce)
                    .flatMap { user in
                        self.container.services.userService.addUser(user)
                    }
                    .sink { [weak self] completion in
                        // 실패
                        if case .failure = completion {
                            self?.isLoading = false
                        }
                    } receiveValue: { [weak self] user in
                        self?.isLoading = false
                        self?.userId = user.id
                        self?.authState = .authenticated
                    }.store(in: &subscriptions)
            } else if case let .failure(error) = result {
                self.isLoading = false
                print(error.localizedDescription)
            }
        case .logout:
            container.services.authService.logout()
                .sink { completion in

                } receiveValue: { [weak self] _ in
                    self?.authState = .unauthenticated
                    self?.userId = nil
                }.store(in: &subscriptions)
        }
    }
}
 
