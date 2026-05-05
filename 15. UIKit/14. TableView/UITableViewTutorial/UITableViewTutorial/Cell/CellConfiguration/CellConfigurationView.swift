//
//  CellConfigurationView.swift
//  UITableViewTutorial
//
//  Created by 김동현 on 5/12/25.
//

import UIKit

// 뷰 안에 컨텐츠 Config를 가지고 있는 뷰
class CellConfigurationView: UIView, UIContentView {
    
    // 여러 데이터를 가진 덩어리
    fileprivate var customConfiguration: MyCellConfiguration!
    
    // 데이터와 UI를 연결
    fileprivate func applyConfigAndChangeUI(_ newConfiguration: MyCellConfiguration) {
        self.customConfiguration = newConfiguration
        titleLabel.text = newConfiguration.title
        bodyLabel.text = newConfiguration.body
    }
    
    var configuration: UIContentConfiguration {
        get { customConfiguration }
        set {
            if let newConfiguration = newValue as? MyCellConfiguration {
                applyConfigAndChangeUI(newConfiguration)
            }
        }
    }
   
    init(config: MyCellConfiguration) {
        super.init(frame: .zero)
        configureUI()
        applyConfigAndChangeUI(config)
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "타이틀 라벨타이틀 라벨타이틀 라벨타이틀 라벨타이틀 라벨"
        label.numberOfLines = 1
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨"
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    fileprivate func configureUI() {
        self.backgroundColor = .systemBlue
        
        // 타이틀 라벨 설정
        self.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
        
        // 바디 라벨 설정
        self.addSubview(self.bodyLabel)
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            bodyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            bodyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            bodyLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

#if DEBUG
import SwiftUI

struct CellConfigurationView_PreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        CellConfigurationView(config: MyCellConfiguration(title: "오늘도 코딩", body: "바디부분")).getPreview()
            .previewLayout(.fixed(width: 200, height: 100))
    }
}
#endif
