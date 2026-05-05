//
//  RxCell.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/16/25.
//

import UIKit

/*
// MARK: - Cell
final class RxCell: UITableViewCell {
    
    // 디버깅용
    var cellData: Todo? = nil
    
    // (uuid, 변경된상태)
    var isDoneChange: ((Int, _ newValue: Bool) -> Void)? = nil
    
    lazy var isDoneSwitch: UISwitch = {
        let sw = UISwitch()
        return sw
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var idLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [titleLabel, idLabel])
        st.axis = .vertical
        return st
    }()
    
    private lazy var hStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [vStack, isDoneSwitch])
        st.axis = .horizontal
        return st
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print(#fileID, #function, #line, "prepareForReuse() - cellData.id: \(cellData?.id ?? 0)")
    }
    
    // 원래는 awakefromnib을 타지만 코드로 UI를 진행한다면 awakefromnib을 타지 않는다.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        /// 부모의 로직을 싱행시키는 의미
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
        constraints()
        
        isDoneSwitch.addTarget(self,
                               action: #selector(handleIsDOne),
                               for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        [hStack].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    @objc func handleIsDOne(_ sender: UISwitch) {
        print(#fileID, #function, #line, "- id: \(cellData?.id ?? 0), sendar: \(sender.isOn)")
        guard let id = self.cellData?.id else { return }
        isDoneChange?(id, sender.isOn)
    }
}

extension RxCell {
    func configure(with todo: Todo) {
        self.cellData = todo
        titleLabel.text = todo.title
        idLabel.text = "ID: \(todo.id)"
        isDoneSwitch.isOn = todo.isDone
    }
}

*/
