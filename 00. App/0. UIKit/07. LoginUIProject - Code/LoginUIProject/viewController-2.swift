//
//  viewController-2.swift
//  LoginUIProject
//
//  Created by 김동현 on 2/16/25.
//

import UIKit

class ViewController2: UIViewController {
    
    // 클로저의 실행문 타입 방식(클로저를 실행하면 view 리턴하여 emailTextFieldView에 담는다)
    // 장점: 설정하는 코드를 넣을 수 있다
    // 앱실행하면 UIViewController인스턴스가 메모리에 올라가는 순간에 저장속성도 생기는데 이와 동시에 클로저가 실행되고, 내부에서 UIView를 만들어 세팅을 한 후 리턴된다.
    let emailTextFieldView: UIView = {
        // UIView의 인스턴스를 만들어서 view변수에 저장
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        // let으로 선언하면 안되고 lazy var로 해줘야 가능
        // lazy var로 선언하면 메모리에 emailTextFieldView가 나중에 생긴다 하지만 ViewController가 생성될 때 view는 먼저 생성되야한다.(addsubview를 하기 위해)
        // view가 먼저 생성되고 나중에 emailTextFieldView가 생성되어서 올릴 수 있다
        
        // MARK: - let으로 선언하고 view.addSubview를 외부에 위치시켜도 된다
        //  view.addSubview(emailTextFieldView)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    func makeUI() {
        
        view.addSubview(emailTextFieldView)
        
        // MARK: - 3) 오토레이아웃을 잡는 코드
        emailTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        emailTextFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        emailTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        emailTextFieldView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        emailTextFieldView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}

#Preview {
    ViewController2()
}
