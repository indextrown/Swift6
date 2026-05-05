//
//  AuthenticationViewModel.swift
//  LMessenger
//
//  Created by 김동현 on 1/13/25.
//

import Foundation
import Combine
import AuthenticationServices

enum AuthenticationState {
    case unauthenticated
    case authenticated
}

final class AuthenticationViewModel: ObservableObject {
    
    // MARK: - view에서 원하는 액션 처리를 위한 액션 정의
    enum Action {
        case chechAuthenticationState
        case googleLogin
        case appleLogin(ASAuthorizationAppleIDRequest)
        case appleLoginCompletion(Result<ASAuthorization, Error>)
        case logout
    }
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var isLoading: Bool = false
    var userId: String?
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    private var currentNonce: String?
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(action: Action) {
        switch action {
        case .chechAuthenticationState:
            if let userId = container.services.authService.chechAuthenticationState() {
                self.userId = userId
                self.authenticationState = .authenticated
            }
        case .googleLogin:
            isLoading = true // 로그인중
            
            // MARK: - sink하면 subscriptions이 return된다 이를 viewModel에서 관리할건데 구독이 하나만 이루어지는게 아니라서 set으로 관리하자
            container.services.authService.signInWithGoogle()
                // MARK: - 성공시 DB추가 작업
                // Google 로그인 작업이 성공(User 객체 반환)하면, .flatMap을 통해 반환된 User를 받아서 데이터베이스에 추가 작업을 수행
                 
                // MARK: - 실패시
                /*
                 sink를 사용해 최종 처리
                 실패 시: sink의 completion 블록에서 .failure를 확인하여 실패 처리 로직을 실행합니다. 여기서는 isLoading을 false로 설정해 로딩 상태를 종료합니다.
                 성공 시: sink의 receiveValue 블록에서 user 정보를 받아 성공 처리 로직을 실행합니다.
                 */
                .flatMap { user in
                    self.container.services.userService.addUser(user)
                }
                .sink { [weak self] completion in
                    // 스트림이 끝날 때 호출 공간(항상 실행됨)
                    
                    // 실패시 작업
                    /*
                    if case .failure = completion {
                        self?.isLoading = false
                    }
                     */
                    
                    /*
                    switch completion {
                    case .finished:
                        print("✅ User added successfully.")
                    case .failure(let error):
                        print("❌ Firebase 에러: \(error.localizedDescription)") // 최종 출력
                        self?.isLoading = false
                    }
                     */
                    
                    // Result<Void, ServiceError>
                    switch completion {
                    case .finished:
                        print("✅ 유저가 성공적으로 추가되었습니다!")
                        
                    // completion이 .failure인 경우, error는 ServiceError 타입이다
                    // error는 ServiceError의 다양한 케이스 중 하나
                    // ServiceError.dbError
                    case .failure(let error):
                        if case .dbError(let dbError) = error {
                            // ❌ error가 .dbError 케이스일 경우 실행 - ServiceError{DBError}
                            print(dbError.errorDescription)
                        } else {
                            // ❌ 다른 ServiceError 처리
                            print("❌ Service 에러: \(error.localizedDescription)")
                        }

                        self?.isLoading = false
                    }
                // 실패시 receiveValue는 일어나지 않음
                } receiveValue: { [weak self] user in
                    self?.isLoading = false // 값을 받았을 때
                    // 유저정보가 오면 이 뷰에서 유저정보id를 가지고 있자
                    self?.userId = user.id
                    self?.authenticationState = .authenticated
                }.store(in: &subscriptions)
            
        case let .appleLogin(request):
            let nonce = container.services.authService.handleSignInWithAppleRequest(request)
            currentNonce = nonce
            
        case let .appleLoginCompletion(result):
            if case let .success(authorization) = result {
                guard let nonce = currentNonce else { return }
                container.services.authService.handleSignInWithAppleCompletion(authorization, nonce: nonce)
                    .flatMap { user in
                        self.container.services.userService.addUser(user)
                    }
                    .sink { [weak self] completion in
                        /*
                        // 실패시 작업
                        // completion 값이 .failure라면
                        if case .failure = completion {
                            self?.isLoading = false
                        }
                        */
                        switch completion {
                        case .finished:
                            print("✅ 유저가 성공적으로 추가되었습니다!")
                        case .failure(let error):
                            if case .dbError(let dbError) = error {
                                // ❌ 에러 ServiceError{DBError}
                                print(dbError.errorDescription)
                                //print("\(String(describing: dbError.errorDescription))")
                                
                            } else {
                                print("❌ Service 에러: \(error.localizedDescription)")
                            }
                            self?.isLoading = false
                        }
                    } receiveValue: { [weak self] user in
                        self?.isLoading = false
                        self?.userId = user.id
                        self?.authenticationState = .authenticated
                    }.store(in: &subscriptions)
            } else if case let .failure(error) = result {
                print(error.localizedDescription)
                self.isLoading = false
            }
        case .logout:
            container.services.authService.logout()
                .sink { completion in
                    
                } receiveValue: { [weak self] _ in
                    self?.authenticationState = .unauthenticated
                    self?.userId = nil
                }.store(in: &subscriptions)
        }
    }
}
