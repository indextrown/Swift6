//
//  ViewController.swift
//  LoginUIProject
//
//  Created by 김동현 on 2/16/25.
//

import UIKit

/*
 
 final
 - 클래스는 구조체보다 느리다
 - 동적 디스패치(table dispatch)가 일어나기 떄문
 - final를 붙히면 상속을 못하게 막아서 메서드가 direct dispatch가 일어나게 해준다
 
 private
 - 외부에서 접근하지 못하고 클래스 내에서만 접근가능하도록 해주는 키워드
 - 접근제어의 개념에서 대부분 변수들은 private를 붙혀주자
 
 lazy var vs let
 - let을 사용하면 메모리에 동시에 올라가기 때문에 순서보장이안됨 -> addSubview를 하려면 괄호 내부가 먼저 생성되야하고 view에 올려야함
 - lazy var를 사용하면 addSubview 사용가능
 
 private lazy var emailTextFieldView: UIView = {
     let view = UIView()
     view.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
     view.layer.cornerRadius = 5
     view.clipsToBounds = true
     view.addSubview(emailTextField) // 가장 밑에있는 뷰에 어떤 뷰를 올리는것
     view.addSubview(emailInfoLabel)
     return view
 }()
 
 */

final class ViewController: UIViewController {
    
    private let loginView = LoginView()
     
    // MARK: - loadView는 viewDidLoad 보다 먼저 실행됨 - 여기서 기본 view 교체 해준다
    override func loadView() {
        // super.loadView() 필요없음
        
        // 기본 view를 loginView로 교체 시켜준다
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAddTarget()
    }
    
    func setAddTarget() {
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginView.passwordResetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - present는 viewController에 존재하기때문에 여기 유지
    @objc private func resetButtonTapped() {
        let alert = UIAlertController(title: "비밀번호 바꾸기", message: "비밀번호를 바꾸시겠습니까?", preferredStyle: .alert)
        let success = UIAlertAction(title: "확인", style: .default) { action in
            print("확인 버튼이 눌렸습니다.")
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel) { cancel in
            print("취소 버튼이 눌렸습니다.")
        }
        
        // alert창 위에 액션을 올리는 것
        alert.addAction(success)
        alert.addAction(cancel)
        
        // 다음 화면으로(alert창) 넘어가는 메서드
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 로그인 버튼을 눌러서 다음 화면으로 넘어가는 동작(present)는 반드시 viewController에서 진행해야함
    @objc private func loginButtonTapped() {
        print("로그인 버튼이 눌렸습니다.")
    }
}

#Preview {
    ViewController()
}
