//
//  ViewController.swift
//  uikit-social-login
//
//  Created by 김동현 on 4/6/25.
//

import UIKit


// 파이어베이스
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

// 구글 로그인
import GoogleSignIn

// 애플 로그인
import CryptoKit
import AuthenticationServices

// 카카오 로그인
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

final class ViewController: UIViewController {
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    private lazy var kakaoLoginButton: UIButton = {
        let button = UIButton(type: .system)
        let logoSize = CGSize(width: 24, height: 24)
        let image = UIImage(named: "Logo Kakao")?
            .resized(to: logoSize)
            .withRenderingMode(.alwaysOriginal)
        
        var config = UIButton.Configuration.filled()
        config.title = "카카오로 계속하기"
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            return outgoing
        }
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseBackgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.0, alpha: 1.0) // 카카오 노란색
        config.baseForegroundColor = .black
        button.configuration = config
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        // ✅ 상태에 따라 배경색 바꾸기
        button.configurationUpdateHandler = { button in
            var config = button.configuration
            if button.isHighlighted {
                config?.baseBackgroundColor = UIColor(red: 0.8, green: 0.72, blue: 0.0, alpha: 1.0) // 눌렸을 때 진한 노랑
            } else {
                config?.baseBackgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.0, alpha: 1.0) // 기본 노랑
            }
            button.configuration = config
        }
        
        button.addTarget(self, action: #selector(handleKakaoLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var googleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        let logoSize = CGSize(width: 24, height: 24)
        let image = UIImage(named: "Logo Apple")?
            .resized(to: logoSize)
            .withRenderingMode(.alwaysOriginal)
        var config = UIButton.Configuration.filled()
        config.title = "Google로 계속하기"
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            return outgoing
        }
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseBackgroundColor = .gray
        config.baseForegroundColor = .black
        
        button.configuration = config
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        // ✅ 상태에 따라 배경색 바꾸기
        button.configurationUpdateHandler = { button in
            var config = button.configuration
            if button.isHighlighted {
                config?.baseBackgroundColor = .gray // 눌렸을 때 진한 노랑
            } else {
                config?.baseBackgroundColor = .white // 기본 노랑
            }
            button.configuration = config
        }
        
        button.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var appleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        let logoSize = CGSize(width: 24, height: 24)
        
        let image = UIImage(systemName: "apple.logo")?
        // UIImage(named: "Logo Apple")?
        //.resized(to: logoSize)
            .withRenderingMode(.alwaysOriginal)
        //.resizedWithVerticalOffset(to: logoSize, yOffset: -1)
        
        var config = UIButton.Configuration.filled()
        config.title = "Apple로 계속하기"
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            return outgoing
        }
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        
        button.configuration = config
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        // ✅ 상태에 따라 배경색 바꾸기
        button.configurationUpdateHandler = { button in
            var config = button.configuration
            if button.isHighlighted {
                config?.baseBackgroundColor = UIColor(white: 0.9, alpha: 1.0) // 눌렀을 때 약간 회색
            } else {
                config?.baseBackgroundColor = .white // 원래 흰색
            }
            button.configuration = config
        }
        
        button.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
        return button
    }()
    
    private let loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        
    }
    
    private func makeUI() {
        // 배경색 설정
        view.backgroundColor = #colorLiteral(red: 0.09411741048, green: 0.09411782771, blue: 0.102702044, alpha: 1)
        
        // 버튼 -> 스택뷰에 추가
        loginStackView.addArrangedSubview(kakaoLoginButton)
        loginStackView.addArrangedSubview(googleLoginButton)
        loginStackView.addArrangedSubview(appleLoginButton)
        
        // 스택 -> view에 추가 + 오토레이아웃 설정
        view.addSubview(loginStackView)
        loginStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // 오토레이아웃 제약 추가
        NSLayoutConstraint.activate([
            // 위치 제약
            loginStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor), // x축 가운데 정렬
            loginStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50), // loginStackView 바닥이 view의 loginStackView으로부터 50
            
            // 크기 제약
            loginStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30), // 스택뷰 왼쪽 시작 위치(실질적으로 좌우폭을 간접적으로 폭을 제한)
            loginStackView.heightAnchor.constraint(equalToConstant: 125) // 고정 높이
            
        ])
    }
}

extension ViewController {
    @objc private func handleKakaoLogin() {
        print("✅ 카카오 로그인 버튼 눌림")
        startKakaoFirebaseLoginFlow()
    }
    
    @objc private func handleGoogleLogin() {
        print("✅ 구글 로그인 버튼 눌림")
        startGoogleLoginFlow()
    }
    
    @objc private func handleAppleLogin() {
        print("✅ 애플 로그인 버튼 눌림")
        startSignInWithAppleFlow()
    }
}

#Preview {
    ViewController()
}


extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}


// extension UIImage {
//     func resizedWithVerticalOffset(to size: CGSize, yOffset: CGFloat) -> UIImage {
//         UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
//         let rect = CGRect(origin: CGPoint(x: 0, y: yOffset), size: size)
//         draw(in: rect)
//         let adjustedImage = UIGraphicsGetImageFromCurrentImageContext()
//         UIGraphicsEndImageContext()
//         return adjustedImage ?? self
//     }
// }
//

extension UIImage {
    func withVerticalOffset(_ offset: CGFloat) -> UIImage {
        return self.withAlignmentRectInsets(UIEdgeInsets(top: -offset, left: 0, bottom: offset, right: 0))
    }
}

// MARK: - 구글 로그인
extension ViewController {
    /// 구글 로그인 시작하기
    func startGoogleLoginFlow() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in // [unowned self]
            guard error == nil else {
                // ...
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                // ...
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                
                // At this point, our user is signed in
            }
            
        }
    }
}

// MARK: - 애플 로그인
extension ViewController {
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
    /// 애플 로그인 플로우
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if error != nil {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription as Any)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
                print(#fileID, #function, #line, "- 애플 로그인 성공")
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}




// MARK: - 카카오톡 로그인
extension ViewController {
    
    /// 카카오톡 로그인 시작
    func startKakaoFirebaseLoginFlow() {
        print(#fileID, #function, #line, "- ")
        fetchKakaoOpenIdToken { idToken in
            guard let idToken = idToken else { return }
            
            /*
            let credential = OAuthProvider.credential(
                withProviderID: "oidc.kakao",  // As registered in Firebase console.
                idToken: idToken,  // ID token from OpenID Connect flow.
                rawNonce: "")
            */
            
            let credential = OAuthProvider.credential(
                providerID: .custom("oidc.kakao"),
                idToken: idToken,
                rawNonce: "")
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if error != nil {
                    print(#fileID, #function, #line, "- 에러: \(error!)")
                    return
                }
                // User is signed in.
                // IdP data available in authResult?.additionalUserInfo?.profile
                print(#fileID, #function, #line, "- 카카오 로그인 성공")
                
            }
        }
    } // startKakaoFirebaseLoginFlow
    
    // MARK: - 카카오 로그인하고 OpenID 토큰 가져오기 클로저 비동기 함수
    /// 클로저 안에서 터지면 escaping해준다
    /// 데이터가 없을 수 도 있으니 옵션널
    func fetchKakaoOpenIdToken(completion: @escaping (String?) -> Void) {
        // 카카오톡 실행 가능 여부 확인
        // 1. 카카오톡이 설치되어 있다면
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 2. 카카오톡으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    // 성공 시 동작 구현
                    _ = oauthToken
                    completion(oauthToken?.idToken)
                }
            }
        } else {
            // 3. 웹브라우저로 로그인 시도
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")

                        // 성공 시 동작 구현
                        _ = oauthToken
                        completion(oauthToken?.idToken)
                    }
                }
        }
    }
}
