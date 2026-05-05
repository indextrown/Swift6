//
//  TestViewController.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 7/27/25.
//

/*
 https://k-elon.tistory.com/22
 */

import UIKit
import SnapKit
import Then
import Combine

final class FirstViewController: UIViewController {
    
    // MARK: - Combine
    @Published var loadingState: LoadingButton.LoadingState = .normal
    var subscriptions = Set<AnyCancellable>()
    
    lazy var myScrollView: UIScrollView = UIScrollView().then {
        $0.isUserInteractionEnabled = true
        $0.alwaysBounceVertical = true
        $0.alwaysBounceHorizontal = false
        $0.addSubview(containerView)
    }
    
    lazy var containerView: UIView = UIView().then {
        $0.backgroundColor = .systemYellow
        $0.addSubview(vStackView)
    }
    
    lazy var vStackView: UIStackView = UIStackView().then {
        $0.axis = .vertical           // 방향: 위 → 아래 (세로)
        $0.spacing = 10               // 뷰 사이 간격 10pt
        $0.alignment = .fill          // 수평 방향으로 StackView 폭을 꽉 채움
        $0.distribution = .fillEqually // 각 뷰의 **높이**를 균등하게
    }
    
    /*
    lazy var hStackView: UIStackView = UIStackView().then {
        $0.axis = .horizontal         // 방향: 왼쪽 → 오른쪽 (가로)
        $0.spacing = 10               // 뷰 사이 간격 10pt
        $0.alignment = .fill          // 수직 방향으로 StackView 높이를 꽉 채움
        $0.distribution = .fillEqually // 각 뷰의 **너비**를 균등하게
    }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    } // viewDidLoad
    
    
    /// UI 설정
    private func setupUI() {
        print(#fileID, #function, #line, "- ")
        self.view.backgroundColor = .systemYellow
        self.view.addSubview(myScrollView)
        
        // scrollView
        myScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // containerView
        containerView.snp.makeConstraints {
            $0.width.equalTo(myScrollView.frameLayoutGuide.snp.width)
            $0.edges.equalTo(myScrollView.contentLayoutGuide.snp.edges)
        }
        
        // vStack
        vStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        /*
        let image = UIImage(systemName: "square.and.arrow.up")
        let dummyButtons = Array(1...10).map { index in
            AlignedIconButton2(iconAlign: .leading,
                              title: "\(index) 버튼",
                              radius: 16,
                              image: image)
        }
        
        dummyButtons.forEach {
            vStackView.addArrangedSubview($0)
        }
         */
        

        let kakaoBtn = AlignedIconButton2(iconAlign: .leading,
                                          title: "카카오로 계속하기",
                                          bgColor: .yellow,
                                          fgColor: .black,
                                          image: UIImage(named: "Logo Kakao"),
                                          padding: .init(top: 10, leading: 10, bottom: 10, trailing: 10))
        
        let appleBtn = AlignedIconButton2(iconAlign: .leading,
                                          title: "Apple로 계속하기",
                                          bgColor: .white,
                                          fgColor: .black,
                                          radius: 10,
                                          image: UIImage(named: "Logo Apple"),
                                          padding: .init(top: 10, leading: 10, bottom: 10, trailing: 10))
        
        let appleBtn2 = AlignedIconButton4(iconAlign: .leading,
                                          title: "Apple로 계속하기",
                                          bgColor: .white,
                                          fgColor: .black,
                                          image: UIImage(named: "Logo Apple"),
                                          padding: .init(top: 10, left: 10, bottom: 10, right: 10))
        
        let kakaoBtn3 = CustomIconButton(iconAlign: .leading,
                                          title: "카카오로 계속하기",
                                          bgColor: .yellow,
                                          fgColor: .black,
                                          image: UIImage(named: "Logo Kakao"),
                                          padding: .init(top: 10, leading: 10, bottom: 10, trailing: 10))
        
        let appleBtn3 = CustomIconButton(iconAlign: .leading,
                                          title: "Apple로 계속하기",
                                          font: UIFont.pretendard(.bold, size: 18),
                                          bgColor: .white,
                                          fgColor: .black,
                                          image: UIImage(named: "Logo Apple"),
                                          padding: .init(top: 10, leading: 10, bottom: 10, trailing: 10))
        
        let loadingBtn = LoadingButton(title: "Loading")
        loadingBtn.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        // MARK: - Combine Publisher 데이터 상태를 <-> 버튼의 loadingState에 연결
        self.$loadingState
            .assign(to: \.loadingState, on: loadingBtn)
            .store(in: &subscriptions)

        [kakaoBtn, appleBtn, appleBtn2, kakaoBtn3, appleBtn3, loadingBtn].forEach {
            vStackView.addArrangedSubview($0)
        }
    }
}

// MARK: - 액션 관련
extension FirstViewController {

    /// 버튼 클릭시
    /// - Parameter sender: 클릭한 버튼
    @objc private func buttonClicked(_ sender: LoadingButton) {
        // MARK: - 센더 기준
        /*
        if sender.loadingState == .normal {
            sender.loadingState = .loading
        } else {
            sender.loadingState = .normal
        }
         */
        
        if self.loadingState == .loading {
            return
        }
        
        self.loadingState = .loading
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loadingState = .normal
        }
        
        
        // MARK: - 콤바인 publisher 데이터 상태를 변경한다 (버튼 자체의 로딩 변경이 아닌 데이터 상태를 변경한것이다)
        /*
        if self.loadingState == .normal {
            self.loadingState = .loading
        } else {
            self.loadingState = .normal
        }
         */
    }
}

#if DEBUG
import SwiftUI

struct FirstViewController_Previews: PreviewProvider {
    static var previews: some View {
        FirstViewController()
            .getPreview()
            .ignoresSafeArea()
    }
}
#endif
