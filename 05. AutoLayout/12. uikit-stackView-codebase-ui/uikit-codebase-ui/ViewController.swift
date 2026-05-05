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
import Then


class ViewController: UIViewController {

    
    // 애니메이션쓸떄 lazy?
    // 이 변수를 사용할 때 메모리에 올라가는 형식
    // {}() 함수블럭이다. return 필요
    /*
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
     */
    
    // MARK: - Then
    lazy var topStackView = UIStackView().then {
        $0.spacing = 10
        $0.alignment = .center
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    /// viewController가 메모리에 올라간다면 즉 load될 때 viewDidload 설정됨
    override func viewDidLoad() { 
        super.viewDidLoad()
        
        let firstView = generateCardView()
        let secondView = generateCardView()
        let thirdView = MyCardView.generateMycardView()
        
        topStackView.addArrangedSubview(firstView)
        topStackView.addArrangedSubview(secondView)
        topStackView.addArrangedSubview(thirdView)
        
        // 서브뷰로 추가(스택뷰는 빈 껍데기 -> 물풍선은 물을 넣기 전까지는 크기를 갖지 않는 것과 동일)
        // 스택뷰에 차곡차곡 item을 넣어줘여함 -> addArrangeView()
        self.view.addSubview(topStackView)
        /*
        // 위치 잡기
        NSLayoutConstraint.activate([
            topStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor), /// 가운데위치가 부모의 가운데위치와 같다
            topStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            topStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
        ])
         */
        topStackView.snp.makeConstraints {
            $0.centerX.equalTo(self.view.snp.centerX)
            $0.top.equalTo(self.view.snp.top).offset(100)
            $0.leading.equalTo(self.view.snp.leading).offset(20)
        }
        
        /// -------------------------------------------------------------------------------------------------------------------------------------
        ///
        
        let secondStackView = generateJellyStackView()
        self.view.addSubview(secondStackView)
        /*
        NSLayoutConstraint.activate([
            // secondStackView의 위치
            secondStackView.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor),
            secondStackView.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor),
            secondStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 20)
        ])
         */
        secondStackView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self.topStackView.snp.horizontalEdges)
            $0.top.equalTo(self.topStackView.snp.bottom).offset(20)
        }
        
        /// -------------------------------------------------------------------------------------------------------------------------------------
        ///
        
        let thirdStackView = generateKakaoStackView()
        self.view.addSubview(thirdStackView)
        /*
        NSLayoutConstraint.activate([
            // thirdStackView의 위치
            thirdStackView.leadingAnchor.constraint(equalTo: secondStackView.leadingAnchor),
            thirdStackView.trailingAnchor.constraint(equalTo: secondStackView.trailingAnchor),
            thirdStackView.topAnchor.constraint(equalTo: secondStackView.bottomAnchor, constant: 20)
        ])
         */
        thirdStackView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(secondStackView.snp.horizontalEdges)
            $0.top.equalTo(secondStackView.snp.bottom).offset(20)
        }
        
        /// -------------------------------------------------------------------------------------------------------------------------------------
        ///
        /*
        let fourthStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [
                generateKakaoStackView(),
                generateKakaoStackView(),
                generateKakaoStackView(),
                generateKakaoStackView()
            ])
            stackView.spacing = 5
            stackView.alignment = .center
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            stackView.backgroundColor = UIColor.systemYellow
            stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layer.borderColor = UIColor.systemBlue.cgColor
            stackView.layer.borderWidth = 2
            stackView.layer.cornerRadius = 10
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        */
        let fourthStackView = UIStackView().then {
            $0.addArrangedSubview(generateKakaoStackView())
            $0.addArrangedSubview(generateKakaoStackView())
            $0.addArrangedSubview(generateKakaoStackView())
            $0.addArrangedSubview(generateKakaoStackView())
            
            $0.spacing = 5
            $0.alignment = .center
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.backgroundColor = UIColor.systemYellow
            $0.directionalLayoutMargins = NSDirectionalEdgeInsets(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layer.borderColor = UIColor.systemBlue.cgColor
            $0.layer.borderWidth = 2
            $0.layer.cornerRadius = 10
        }
        
        self.view.addSubview(fourthStackView)
        /*
        NSLayoutConstraint.activate([
            // fourthStackView의 위치
            fourthStackView.leadingAnchor.constraint(equalTo: thirdStackView.leadingAnchor),
            fourthStackView.trailingAnchor.constraint(equalTo: thirdStackView.trailingAnchor),
            fourthStackView.topAnchor.constraint(equalTo: thirdStackView.bottomAnchor, constant: 20)
        ])
        */
        fourthStackView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(thirdStackView.snp.horizontalEdges)
            $0.top.equalTo(thirdStackView.snp.bottom).offset(20)
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
    
    /// 젤리스택뷰 생성
    /// - Returns: 생성된 스택뷰
    fileprivate func generateJellyStackView() -> UIStackView {
        let leadingImageView = UIImageView()
        leadingImageView.image = UIImage(systemName: "pencil.circle.fill")
        leadingImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // 크기
            leadingImageView.widthAnchor.constraint(equalToConstant: 50),
            leadingImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let centerLabel = UILabel()
        centerLabel.text = "젤리교환소"
        centerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let trailingImageView = UIImageView()
        trailingImageView.image = UIImage(systemName: "pencil.circle.fill")
        trailingImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // 크기
            trailingImageView.widthAnchor.constraint(equalToConstant: 50),
            trailingImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
         
        // MARK: - 스택뷰 활용(스택뷰는 아이템 요소의 크기에 종속된다 -> 아이템 요소 크기를 정해주자)
        let secondStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [leadingImageView, centerLabel, trailingImageView])
            stackView.spacing = 0
            stackView.alignment = .center
            stackView.axis = .horizontal
            stackView.distribution = .equalCentering
            stackView.backgroundColor = UIColor.systemYellow
            stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layer.borderColor = UIColor.systemBlue.cgColor
            stackView.layer.borderWidth = 2
            stackView.layer.cornerRadius = 10
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        return secondStackView
    }
    
    
    /// 카카오스택뷰 생성
    /// - Returns: 생성된 스택뷰
    fileprivate func generateKakaoStackView() -> UIStackView {
        
        let firstLabel = UILabel()
        firstLabel.text = "내 카카오뱅크 입출금 통장"
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let secondLabel = UILabel()
        secondLabel.text = "젤리 교환소"
        secondLabel.font = UIFont.systemFont(ofSize: 12 )
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let trailingImageView = UIImageView()
        trailingImageView.image = UIImage(systemName: "pencil.circle.fill")
        trailingImageView.translatesAutoresizingMaskIntoConstraints = false
        /*
        NSLayoutConstraint.activate([
            // 크기
            trailingImageView.widthAnchor.constraint(equalToConstant: 20),
            trailingImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
         */
        trailingImageView.snp.makeConstraints {
            // $0.width.equalTo(20)
            // $0.height.equalTo(20)
            $0.size.equalTo(30)
        }
         
        // MARK: - 스택뷰 활용(스택뷰는 아이템 요소의 크기에 종속된다 -> 아이템 요소 크기를 정해주자)
        let secondStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [firstLabel, secondLabel, trailingImageView])
            stackView.spacing = 0
            stackView.alignment = .center
            stackView.axis = .horizontal
            stackView.distribution = .equalCentering
            stackView.backgroundColor = UIColor.systemYellow
            stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layer.borderColor = UIColor.systemBlue.cgColor
            stackView.layer.borderWidth = 2
            stackView.layer.cornerRadius = 10
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        return secondStackView
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


