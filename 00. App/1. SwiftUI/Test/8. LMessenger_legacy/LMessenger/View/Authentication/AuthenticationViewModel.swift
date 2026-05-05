//
//  AuthenticationViewModel.swift
//  LMessenger
//
//  Created by 김동현 on 10/30/24.
//

import Foundation
import Combine
import AuthenticationServices

enum AuthenticationState {
    case unauthenticated
    case authenticated
}

class AuthenticationViewModel: ObservableObject {
    
    enum Action {
        case googleLogin
        case appleLogin(ASAuthorizationRequest)
        case appleLoginCompletion(Result<ASAuthorization, Error>)
        case checkAuthenticationState
        case logout
    }
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var isLoading = false
    
    var userId: String?
    
    private var currentNonce: String?
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
        
        // container.services.authService
    }
    
    
    func send(action: Action) {
        switch action {
        case .checkAuthenticationState:
            if let userId = container.services.authService.checkAuthenticationState() {
                self.userId = userId
                self.authenticationState = .authenticated
            }
            
        case .logout:
            container.services.authService.logout()
                .sink { completion in
                      
                } receiveValue: { [weak self] _ in
                    self?.authenticationState = .unauthenticated
                    self?.userId = nil
                }.store(in: &subscriptions)
            
        case .googleLogin:
            isLoading = true
            // MARK: - 구글 로그인 완료가 되면
            container.services.authService.signInWidhGoogle()
                // TODO: - db추가
                .flatMap { user in
                    self.container.services.userService.addUser(user)
                }
                // MARK: - 실패시
                .sink { [weak self] completion in
                    // TODO: - 실패시
                    if case .failure = completion {
                        self?.isLoading = false
                    }
                // MARK: - 성공시
                } receiveValue: { [weak self] user in
                    self?.isLoading = false
                    self?.userId = user.id // 유저정보가 오면 뷰모델에서 아이디 보유하도록
                    self?.authenticationState = .authenticated
                }.store(in: &subscriptions) // sink를 하면 subscriptions가 리턴된다 -> 뷰모델에서 관리
                                            //subscriptions은 뷰모델에서 관리할건데 뷰모델에서 구독이 여러개 있을 수 있어서 set으로 관리하자
                                            
        case let .appleLogin(request):
            let nonce = container.services.authService.handleSignInWithAppleRequest(request as! ASAuthorizationAppleIDRequest)
            currentNonce = nonce
            
        case let .appleLoginCompletion(result):
            if case let .success(authorization) = result {
                guard let nonce = currentNonce else { return }
                
                container.services.authService.handleSignInWithAppleCompletion(authorization, none: nonce)
                    // TODO: - db추가
                    .flatMap { user in
                        self.container.services.userService.addUser(user)
                    }
                    .sink { [weak self] completion in
                        // TODO: - 실패시
                        if case .failure = completion {
                            self?.isLoading = false
                        }
//                        if case let .failure(error) = completion {
//                           print("Apple login failed: \(error.localizedDescription)")
//                       }
                    } receiveValue: { [weak self] user in
                        self?.isLoading = false
                        self?.userId = user.id
                        self?.authenticationState = .authenticated
                    }.store(in: &subscriptions)
            } else if case let .failure(error) = result {
                isLoading = false
                print(error.localizedDescription)
            }
        }
    }
}

