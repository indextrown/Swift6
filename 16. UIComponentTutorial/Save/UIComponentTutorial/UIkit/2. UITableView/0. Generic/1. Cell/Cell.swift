//
//  Cell.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/1/25.
//

import UIKit

// MARK: - Protocol
/*
protocol ReuseIdentifiable {
    /// 프로토콜에서 로직을 정의할 수 없어서 가져올 수 있도록 설정
    static var reuseIdentifier: String { get }
}
extension ReuseIdentifiable {
    /// 로직에 대한 정의는 Extension에서 간능
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
 */

/// 셀을 추상화하여 데이터 바인딩 규약을 정의(선택)
//protocol BindableCell {
//    associatedtype DataType
//    func bind(_ data: DataType)
//}


// MARK: - Cell
/// extension UITableViewCell: ReuseIdentifiable {}
final class CodeCell: UITableViewCell {
    
    // MARK: - UI Component
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "본문"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    // 원래는 awakefromnib을 타지만 코드로 UI를 진행한다면 awakefromnib을 타지 않는다.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier) /// 부모의 로직을 싱행시키는 의미
        makeUI()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindCell(_ data: DummyData) {
        self.titleLabel.text = data.title
        self.bodyLabel.text = data.body
    }
    
    func bindCell(_ data: IndexData) {
        self.titleLabel.text = data.title
        self.bodyLabel.text = data.body
    }
    
    private func makeUI() {
        self.backgroundColor = .systemYellow
        
        [titleLabel, bodyLabel].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func constraints() {
        // 타이틀 라벨 설정
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
        ])
        
        // 바디 라벨 설정
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            bodyLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            bodyLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            bodyLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
}
