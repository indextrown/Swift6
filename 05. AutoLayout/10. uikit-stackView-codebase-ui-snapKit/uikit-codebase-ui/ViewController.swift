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

    // 애니메이션쓸떄 lazy?
    // 이 변수를 사용할 때 메모리에 올라가는 형식
    // {}() 함수블럭이다. return 필요
    lazy var topStackView: UIStackView = {
        /// interfacebuilder와 동일
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    /// viewController가 메모리에 올라간다면 즉 load될 때 viewDidload 설정됨
    override func viewDidLoad() { 
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let firstView = generateCardView()
        let secondView = generateCardView()
        let thirdView = MyCardView.generateMycardView()
        
        topStackView.addArrangedSubview(firstView)
        topStackView.addArrangedSubview(secondView)
        topStackView.addArrangedSubview(thirdView)
        
        // 서브뷰로 추가(스택뷰는 빈 껍데기 -> 물풍선은 물을 넣기 전까지는 크기를 갖지 않는 것과 동일)
        // 스택뷰에 차곡차곡 item을 넣어줘여함 -> addArrangeView()
        self.view.addSubview(topStackView)
        
        // 위치 잡기 - 기존코드
        NSLayoutConstraint.activate([
            topStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor), /// 가운데위치가 부모의 가운데위치와 같다
            topStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            topStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
        ])
         
        // 위치 잡기 - snapKit
        topStackView.snp.makeConstraints {
            // center를 맞추고 한쪽에 offset을 줘서 반대쪽도 대칭이 되도록 적용한 방법
            // 크기
            // 위치 x, y
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100) /// 나를 가지고있는 부모에 맞추고 + 100
            $0.left.equalToSuperview().offset(20) /// right로 햐도되지만 -20 해줘야함
            // $0.horizontalEdges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)) /// 양쪽다 거는방법
        }
    }
}

// MARK: - view 관련
extension ViewController {
    
    // 이렇게 하면 확장된 뷰컨트롤러에서만 호출가능.. 전역적인 방법으로 하려면 카드뷰 클래스에 static 메서드를 활용해보자
    fileprivate func generateMyCustomView() -> UIView {
        let customCardView = MyCardView()
        customCardView.translatesAutoresizingMaskIntoConstraints = false
        return customCardView
    }

    /// 카드뷰 생성 및 반환
    /// - Returns: 카드뷰
    fileprivate func generateCardView() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.systemYellow
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 타이틀
        let titleLabel = UILabel()
        titleLabel.text = "사운드\n테라피"
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 서브타이틀
        let subtitleLabel = UILabel()
        subtitleLabel.text = "무료"
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 컨테이너
        let subtitleLabelBg = UIView()
        subtitleLabelBg.backgroundColor = UIColor.systemMint
        subtitleLabelBg.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabelBg.addSubview(subtitleLabel)
        
        // subtitleLabel 위치
        NSLayoutConstraint.activate([
            // 가운데 정렬
            subtitleLabel.centerXAnchor.constraint(equalTo: subtitleLabelBg.centerXAnchor),
            subtitleLabel.centerYAnchor.constraint(equalTo: subtitleLabelBg.centerYAnchor),
            
            // leading, top 간격을 각각 5만큼
            subtitleLabel.topAnchor.constraint(equalTo: subtitleLabelBg.topAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: subtitleLabelBg.leadingAnchor, constant: 5)
        ])
        
        // 이미지 뷰
        let bottomImageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        bottomImageView.contentMode = .scaleAspectFit // 작아지지만 딱맞게
        //bottomImageView.contentMode = .scaleAspectFill // 일그러지지는 않지만 깨진다
        bottomImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 크기
            bottomImageView.widthAnchor.constraint(equalToConstant: 50),
            bottomImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // firstView에 대한 하위요소 추가
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabelBg)
        containerView.addSubview(bottomImageView)
        
        // firstView에 대한 요소들 위치 잡기 (label은 크기를 가지고 있어서 위치만 잡아주면 된다)
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            bottomImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            bottomImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5)
        ])
        return containerView
    }
}

// 전처리기
#if DEBUG

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


