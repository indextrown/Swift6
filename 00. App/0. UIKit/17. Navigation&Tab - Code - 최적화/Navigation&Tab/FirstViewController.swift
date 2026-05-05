//
//  FirstViewController.swift
//  Navigation&Tab
//
//  Created by 김동현 on 2/26/25.
//

import UIKit

final class FirstViewController: UIViewController, LoginViewControllerDelegate {
    
    // 로그인 여부에 관련된 참/거짓 저장속성
    var isLoggedIn = false
    
    // MARK: - delegate 패턴
    func didLoginSuccessfully() {
        isLoggedIn = true
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    // 다음화면을 띄우는 더 정확한 시점 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isLoggedIn {
            let loginVC = LoginViewController()
            // MARK: - delegate 패턴
            loginVC.delegate = self  // delegate 지정
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false, completion: nil)
        }
    }
    
    // MARK: - 네비게이션바를 코드로 설정
    private func makeUI() {
        view.backgroundColor = .gray
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()                              // 불투명
        navigationBarAppearance.backgroundColor = .white                                     // 네비게이션바 배경 색상
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.systemBlue] // 네비게이션바 텍스트 색상
        navigationController?.navigationBar.tintColor = .blue
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false
        title = "Main"
    }
}
