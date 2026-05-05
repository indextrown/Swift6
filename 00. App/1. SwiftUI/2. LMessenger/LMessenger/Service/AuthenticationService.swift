//
//  AuthenticationService.swift
//  LMessenger
//
//  Created by 김동현 on 1/13/25.
//

/*
 우리는 viewmodel, service, provider layer를 combine으로 연결할것이다.
 - 프로토콜 장점: 프로토콜로 정의하여 **Stub (모의 객체)**를 만들어 테스트하거나, 구현체를 교체할 수 있습니다.
 
 signInWithGoogle()
 - 반환값: Combine의 AnyPublisher:
 - Output: 로그인 성공 시 반환할 User 객체.
 - Failure: 로그인 실패 시 발생할 ServiceError.
 
 Empty
 - 값을 방출하지 않고 종료되는 퍼블리셔입니다.
 
 AnyPublisher
 - AnyPublisher는 Swift의 Combine 프레임워크에서 사용되는 **추상화된 퍼블리셔(Publisher)**입니다. 이는 퍼블리셔의 구체적인 타입을 숨기고, 더 간단한 방식으로 데이터를 스트림 형태로 처리할 수 있도록 설계된 타입입니다.
 - Publisher는 Combine에서 데이터를 비동기적으로 스트림 형태로 전달하는 객체입니다.
 - Publisher는 두 가지 중요한 타입 매개변수를 가집니다:
 - Output: 퍼블리셔가 방출하는 데이터 타입.
 - Failure: 퍼블리셔가 실패 시 방출하는 오류 타입.
 왜 사용?
 - Combine에서 퍼블리셔는 매우 구체적인 타입으로 나타납니다. 여러 연산자를 체이닝하면 퍼블리셔 타입이 점점 더 복잡해질 수 있습니다.
 해결책 -AnyPublisher로 단순화
 - AnyPublisher를 사용하면 복잡한 타입을 숨기고, 단순한 추상화된 타입으로 표현할 수 있습니다.
 
 예시1
 import Combine

 func examplePublisher() -> AnyPublisher<String, Never> {
     let publisher = Just(42)
         .map { "\($0)" }
         .eraseToAnyPublisher() // 복잡한 타입을 AnyPublisher로 변환
     return publisher
 }

 let cancellable = examplePublisher()
     .sink { value in
         print("Received value: \(value)")
     }
-------------------------------------------------------------------------------------
 
 eraseToAnyPublisher
 - Combine 프레임워크에서 사용되는 메서드로, 퍼블리셔(Publisher)를 **AnyPublisher**로 변환하는 데 사용됩니다. 이를 통해 퍼블리셔의 구체적인 타입을 숨기고, 더 간단한 추상화된 타입으로 반환할 수 있습니다.
 - eraseToAnyPublisher()는 Combine에서 구체적인 퍼블리셔 타입을 숨기고 API를 간결하게 유지할 수 있도록 도와주는 중요한 도구입니다. 이를 통해 복잡한 퍼블리셔 체인을 추상화하고, 호출자가 내부 구현에 의존하지 않도록 설계할 수 있습니다.
 
 예제1
 let publisher = Just(42)
     .map { "\($0)" }
     .eraseToAnyPublisher()

 // 타입은 AnyPublisher<String, Never>
 -------------------------------------------------------------------------------------
 
 예제2
 struct NetworkService {
     func fetchData(from url: URL) -> AnyPublisher<Data, URLError> {
         URLSession.shared.dataTaskPublisher(for: url)
             .map(\.data)
             .eraseToAnyPublisher() // AnyPublisher로 반환
     }
 }

 
 */

import Foundation
import Combine
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

// 인증 에러타입
enum AuthenticationError: Error {
    case clientError    // clientID 가져오기 실패
    case tokenError     //
    case invalidated
}

// MARK: - 구글로그인은 Combine을 제공하지 않기 때문에 응답으로 컴플리션 핸들러를 구현하고 그 컴풀리션 핸들러를 가지고 Future로 퍼블리셔를 만들자
// Combine을 활용해 비동기 작업을 처리하려면 기존의 Completion Handler 기반 API를 Combine의 Publisher로 변환해야 한다.
// Combine을 사용하기 위해 Completion Handler를 구현하고 변환한다
/*
 // 구글로그인을 하고 Output값을 User로 지정
 MARK: - Completion Handler?
 - 비동기 작업이 완료된 후, 결과를 처리하기 위해 호출되는 Closure이다
 - Swift에서 비동기 작업은 실행이 완료되는 시간이 일정하지 않을 수 있어서, 작업이 끝난 시점에 필요한 처리를 수행하기 위해 완료 콜백(completion callback)으로 Completion Handler를 사용한다
 - 비동기 작업이 완료된 후 호출되는 클로저입니다. 작업의 성공/실패 결과를 처리하거나 후속 작업을 수행하는 데 사용되며 네트워크 요청, 파일 작업, 지연 작업 등 다양한 비동기 작업에서 활용된다
 
 // Completion Handler 특징
 비동기 작업 처리
 - 작업이 완료될 때 콜백을 호출하여 결과를 전달
 순서 보장
 - 비동기 작업 완료 이후에 실행될 코드를 명확히 제어가능
 코드 흐름 제어
 - 비동기 작업의 성공과 실패에 따른 분기 처리가 가능
 
 MARK: Combine
 - 동기 작업을 처리하는 데 매우 유용한 프레임워크지만, 기본적으로 Combine은 Completion Handler 기반의 작업을 직접적으로 지원하지 않는다
 - Combine은 Publisher와 Subscriber 패턴을 사용하여 데이터 스트림을 처리한다
 - 반면, Completion Handler는 단발성 비동기 작업의 결과를 전달하는 방식이다
 - Combine의 Publisher는 스트림(연속적인 데이터 흐름)을 기반으로 동작하므로, Completion Handler처럼 단일 결과만 반환하는 구조는 Combine과 바로 연결되지 않는다
 - 따라서 Completion Handler 결과를 Combine의 Publisher로 변환해야 Combine에서 사용할 수 있다
 
 MARK: - 변환방법
 - Completion Handler를 Combine으로 변환하려면, Combine의 Future 또는 PassthroughSubject를 사용해 Completion Handler의 결과를 Combine의 Publisher로 만들어야 한다.
 */
protocol AuthenticationServiceType {
    func chechAuthenticationState() -> String?
    func signInWithGoogle() -> AnyPublisher<User, ServiceError>
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String
    func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, nonce: String) -> AnyPublisher<User, ServiceError>
    func logout() -> AnyPublisher<Void, ServiceError>
}

final class AuthenticationService: AuthenticationServiceType {

    // MARK: - 현재 유저정보가 있는지 테스트하고 정보가 있다면 유저 id 추출
    func chechAuthenticationState() -> String? {
        if let user = Auth.auth().currentUser {
            return user.uid
        } else {
            return nil
        }
    }
    
    // Combine 방식의 인터페이스로 외부에 제공하는 역할을 하고, Combine을 사용하는 ViewModel이나 서비스에서 쉽게 구독할 수 있습니다.
    func signInWithGoogle() -> AnyPublisher<User, ServiceError> {
        Future { [weak self] promise in
            self?.signInWithGoogle { result in
                switch result {
                case let .success(user):    // 성공시 유저정보 받음
                    promise(.success(user))
                case let .failure(error):   // 실패시 에러정보 받음
                    promise(.failure(ServiceError.error(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String {
        request.requestedScopes = [.fullName, .email]
        
        // nonce 세팅할건데 nonce는 랜덤스트림을 만들오소 sha암호화를 이용해 만들 것이다
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        return nonce
    }
    func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, nonce: String) -> AnyPublisher<User, ServiceError> {
        Future { [weak self] promise in
            self?.handleSignInWithAppleCompletion(authorization, nonce: nonce) { result in
                switch result {
                case let .success(user):
                    promise(.success(user))
                case let .failure(error):
                    promise(.failure(.error(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, ServiceError> {
        Future { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(ServiceError.error(error)))
            }
        }
        .eraseToAnyPublisher()
    }
}

final class StubAuthenticationService: AuthenticationServiceType {
    
    func chechAuthenticationState() -> String? {
        return nil
    }
    
    func signInWithGoogle() -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> String {
        return ""
    }
    func handleSignInWithAppleCompletion(_ authorization: ASAuthorization, nonce: String) -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}

// MARK: - 컴플리션 핸들러 모음
// MARK: - 구글로그인은 Combine제공하지 않는다 응답으로 completion핸들러 구현하고 completion핸들러 가지고 future로 publisher만드는 작업 진행
// MARK: - 애플로그인도 combine지원하지 않아서 completion handler만들어서 future로 publisher를 만들자
extension AuthenticationService {
    
    // MARK: - 구글 로그인 함수
    // 실제 구글 로그인 비동기 작업을 수행하는 함수. 결과값을 SignInWidhGoogle()에서 combine의 Future로 변환하여 사용 가능.
    private func signInWithGoogle(completion: @escaping (Result<User, Error>) -> Void) {
        // Firebase에서 제공하는 clientID를 가져온다. 실패시 clientIDError를 반환한다.
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(AuthenticationError.clientError))
            return
        }
        
        // GIDConfiguration 객체를 생성하여 Google Sign-In 구성을 초기화한다
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Google Sign-in 창을 띄울 rootViewController을 가져온다
        // 현재 실행 중인 UIApplication에서 UIWindow를 탐색하여 추출한다
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return
        }
        
        // 로그인 진행
        // 성공시 result 객체를 반환
        // result.user에서 idToken, accessToken을 가져온다
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                // 유저정보, 토큰정보가 없다면
                completion(.failure(AuthenticationError.tokenError))
                return
            }
            
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            // 구글 로그인 완료시
            // Firebase인증에 필요한 AuthCredential를 생성하여 authenticateUserWithFirebase로 전달한다
            self?.authenticateUserWithFirebase(credential: credential, completion: completion)
        }
    }
    
    // MARK: - 애플 로그인 함수
    private func handleSignInWithAppleCompletion(_ authorization: ASAuthorization,
                                                 nonce: String,
                                                 completion: @escaping (Result<User, Error>) -> Void) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let appleIDToken = appleIDCredential.identityToken else {
                print("애플 로그인 실패: 유효하지 않은 자격 증명")
            completion(.failure(AuthenticationError.tokenError))
            return
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("애플 로그인 실패: ID 토큰 변환 실패") // 에러 출력 추가
            completion(.failure(AuthenticationError.tokenError))
            return
        }
        
        
        let credential = OAuthProvider.credential(providerID: AuthProviderID.apple,
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
                                          
        
        authenticateUserWithFirebase(credential: credential) { result in
            switch result {
            case var .success(user):
                // ASAuthorizationAppleIDCredential에서 제공된 이름 정보(givenName과 familyName)를 User 객체에 추가
                user.name = [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName]
                    .compactMap{ $0 }
                    .joined(separator: " ")
                completion(.success(user))
            case let .failure(error):
             print("Firebase 인증 실패: \(error.localizedDescription)") // 에러 출력 추가
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 파이어베이스 인증 진행 함수
    private func authenticateUserWithFirebase(credential: AuthCredential, completion: @escaping (Result<User, Error>) -> Void ) {
        // Firebase 서버에 인증 요청을 보낸다
        Auth.auth().signIn(with: credential) { result, error in
            // 인증 실패시 에러를 completion으로 반환한다.
            if let error {
                completion(.failure(error))
                return
            }
            
            // 인증 결과가 없는 경우 invalidated 에러를 반환한다
            guard let result else {
                completion(.failure(AuthenticationError.invalidated))
                return
            }
            
            // 기존 사용자: 기존 uid를 반환
            // 새 사용자: 새로운 uid를 반환
            let firebaseUser = result.user
            
            // User객체 생성
            let user: User = User(id: firebaseUser.uid,
               name: firebaseUser.displayName ?? "",
               phoneNumber: firebaseUser.phoneNumber,
               profileURL: firebaseUser.photoURL?.absoluteString)
            
            // 유저정보까지 설정 문제없으면 컴플리션 핸들러로 유저정보를 보낸다
            completion(.success(user))
        }
    }
}

