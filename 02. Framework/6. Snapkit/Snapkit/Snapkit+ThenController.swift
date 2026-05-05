//
//  SnapkitViewController.swift
//  Snapkit
//
//  Created by 김동현 on 3/1/25.
//

import UIKit
import SnapKit
import Then

final class SnapkitThenController: UIViewController {
    // 박스 확장 상태 나타내는 변수
    private var isExpanded = false
    
    private let label = UILabel().then {
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 20
    }
    
    private let redBox = UIView().then {
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 20
    }
    
    private let blueBox = UIView().then {
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 20
    }
    
    private lazy var button = UIButton().then {
        $0.backgroundColor = .black
        $0.setTitle("버튼", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        setupViews()
    }
    
    private func addSubviews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(redBox)
        stackView.addArrangedSubview(blueBox)
        stackView.addArrangedSubview(button)
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints { $0.center.equalToSuperview() }
        redBox.snp.makeConstraints { $0.width.height.equalTo(100) }
        blueBox.snp.makeConstraints { $0.width.height.equalTo(100) }
        button.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(50)
        }
    }

    private func setupViews() {
        addSubviews()
        setupConstraints()
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
