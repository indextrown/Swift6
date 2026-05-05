//
//  SnapkitViewController.swift
//  Snapkit
//
//  Created by 김동현 on 3/1/25.
//

import UIKit
import SnapKit

final class SnapkitViewController: UIViewController {
    
    // 박스 확장 상태 나타내는 변수
    private var isExpanded = false

    private let redBox: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let blueBox: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var button: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitle("버튼", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return btn
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 20
        sv.alignment = .center
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        
        // 1. stackView를 부모 뷰에 추가
        view.addSubview(stackView)
        
        // 2. stackView에 redBox와 blueBox를 arrangedSubview로 추가
        stackView.addArrangedSubview(redBox)
        stackView.addArrangedSubview(blueBox)
        stackView.addArrangedSubview(button)
        
        // 3. stackView 제약 조건 설정: 부모 뷰의 중앙에 배치
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        // 4. 각 박스 크기 고정
        redBox.snp.makeConstraints {
            $0.width.height.equalTo(100)

        }
        blueBox.snp.makeConstraints {
            $0.width.height.equalTo(100)

        }
        
        // 5. 버튼 크기 설정
        button.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func buttonPressed() {
        isExpanded.toggle()
        
        let newwidth = isExpanded ? 200 : 100
        redBox.snp.updateConstraints {
            $0.width.equalTo(newwidth)
        }
        blueBox.snp.updateConstraints {
            $0.width.equalTo(newwidth)
        }
        
        // 애니메이션추가
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
