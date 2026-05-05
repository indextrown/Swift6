//
//  CodeCell.swift
//  UITableViewTutorial
//
//  Created by 김동현 on 5/11/25.
//

import UIKit

class CodeCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "타이틀 라벨타이틀 라벨타이틀 라벨타이틀 라벨타이틀 라벨"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨바디 라벨"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    fileprivate func configureUI() {
        self.backgroundColor = .systemYellow
        
        // 타이틀 라벨 설정
        self.contentView.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
        ])
        
        // 바디 라벨 설정
        self.contentView.addSubview(self.bodyLabel)
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            bodyLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            bodyLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            bodyLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // 원래는 awakefromnib을 타지만 코드로 UI를 진행한다면 awakefromnib을 타지 않는다.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier) /// 부모의 로직을 싱행시키는 의미
        configureUI()
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

extension UIView {
    private struct ViewRepresentable: UIViewRepresentable {
        let uiView: UIView
        func updateUIView(_ uiView: UIViewType, context: Context) {
        }
        func makeUIView(context: Context) -> some UIView {
            uiView
        }
    }
    
    func getPreview() -> some View {
        ViewRepresentable(uiView: self)
    }
}
#endif

#if DEBUG
import SwiftUI

struct CodeCell_PreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        CodeCell().getPreview()
            .previewLayout(.fixed(width: 200, height: 100))
    }
}
#endif
