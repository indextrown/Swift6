//
//  MyCardView.swift
//  uikit-codebase-ui
//
//  Created by 김동현 on 3/19/25.
//

import Foundation
import UIKit

class MyCardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        print("MycardView")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// 레이아웃 설정
    fileprivate func setupLayout() {
        self.backgroundColor = UIColor.systemYellow
        self.translatesAutoresizingMaskIntoConstraints = false
        
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
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabelBg)
        self.addSubview(bottomImageView)
        
        // firstView에 대한 요소들 위치 잡기 (label은 크기를 가지고 있어서 위치만 잡아주면 된다)
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            bottomImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            bottomImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        ])
    }
}

// MARK: - 스태틱 메서드 관련
extension MyCardView {
    
    /// 카드뷰 만들기
    /// - Returns: 만들어진 카드뷰
    static func generateMycardView() -> MyCardView {
        let cardView = MyCardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }
}
