//
//  ViewController.swift
//  uikit-codebase-ui
//
//  Created by 김동현 on 3/19/25.
//

/*
 [Reference]
 - https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/index.html
 */

import UIKit
import SnapKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let yellowView = UIView()
        yellowView.backgroundColor = UIColor.systemYellow
        yellowView.translatesAutoresizingMaskIntoConstraints = false /// 프레임베이스로 진행을 막기 위해서 해줘야한다
        self.view.addSubview(yellowView)
        
        // MARK: - 일반적인 방식
        // view는 크기가 없어서 크기를 정하고 위치를 정해주자
        NSLayoutConstraint.activate([
            // 크기
            yellowView.widthAnchor.constraint(equalToConstant: 100),
            yellowView.heightAnchor.constraint(equalToConstant: 100),
            
            // 위치
            yellowView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            yellowView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
        
        print(#function)
        
        /*
        // view는 크기가 없어서 크기를 정하고 위치를 정해주자
        // 크기
        yellowView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        yellowView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // 위치
        yellowView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        yellowView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
         */
    }
}


/*
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let yellowView = UIView()
        yellowView.backgroundColor = UIColor.systemYellow
        self.view.addSubview(yellowView)
        
        // MARK: - spankit방식
        yellowView.snp.makeConstraints { make in
            make.size.equalTo(100)
            // make.width.equalTo(100)
            // make.height.equalTo(100)
            // make.center.equalTo(self.view)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
    }
}
 */
 
// 전처리기
#if DEBUG

//#Preview {
//    ViewController()
//}

import SwiftUI

struct ViewControllerPresentable: UIViewControllerRepresentable {
    // 상태가 바뀌면 렌더링이 다시 됨
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    // 처음 뷰를 그릴때 호출
    func makeUIViewController(context: Context) -> some UIViewController {
        ViewController()
    }
}

struct ViewControllerPrepresentable_PreviewProvider : PreviewProvider {
    static var previews: some View {
        ViewControllerPresentable()
            .previewDevice("iPhone 12 mini")
            .previewDisplayName("iPhone 12 mini")
            .ignoresSafeArea()
    }
}

#endif
