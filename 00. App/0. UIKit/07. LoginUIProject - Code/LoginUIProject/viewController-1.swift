//
//  viewController-1.swift
//  LoginUIProject
//
//  Created by 김동현 on 2/16/25.
//

import UIKit

class ViewController1: UIViewController {
    
    // 저장속성에 메모리에 올라간 인스턴스를 담아둠
    let emailTextFieldView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    func makeUI() {
        // MARK: - 1) 백그라운드 설정
        emailTextFieldView.backgroundColor = UIColor.darkGray
        
        // 뷰를 둥글게 하는법
        emailTextFieldView.layer.cornerRadius = 10
        emailTextFieldView.layer.masksToBounds = true
        
        // MARK: - 3) 직접적으로 뷰에 올리는 코드 - 하위뷰에 넣겠다(화면 어디에 올려둘지 몰라서 오토레이아웃 잡아줘야한다)
        view.addSubview(emailTextFieldView)
        
        // MARK: - 이코드는 외우기..(코드로 짜면 뷰가 자동으로 프레임 기준으로 오토래이아웃을 잡아주는데.. 그걸 끄는 기능)
        
        
        // MARK: - 3) 오토레이아웃을 잡는 코드
        // equalTo: 어디를 기준으로 맞출건지: view.leadingAnchor: 기본 뷰의 앞쪽
        emailTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        emailTextFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        emailTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        emailTextFieldView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        emailTextFieldView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}

#Preview {
    ViewController1()
}
