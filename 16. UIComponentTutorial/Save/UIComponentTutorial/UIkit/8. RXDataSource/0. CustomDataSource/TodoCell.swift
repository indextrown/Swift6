//
//  TodoCell.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 8/3/25.
//

import UIKit
import RxSwift
import RxCocoa

final class TodoCell: UITableViewCell {
    
    // 디버깅용
    var cellData: Todo? = nil
    
    
    // MARK: - 클로저 터트리는 방식
    // (uuid, 변경된상태)
    var isDoneChange: ((Int, _ newValue: Bool) -> Void)? = nil
    var deleteAction: ((_ id: Int) -> Void)? = nil
    
    // MARK: - Rx방식
    var disposeBag = DisposeBag()
    
    // MARK: - Rx방식2
    var deleteActionObservable: Observable<Int> = Observable.empty()
    var updateActionObservable: Observable<(id: Int, newValue: Bool)> = Observable.empty()
    
    
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
    
    private lazy var deleteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("삭제", for: .normal)
        btn.setTitleColor(.systemRed, for: .normal)
        btn.addTarget(self, action: #selector(removeBtn), for: .touchUpInside)
        btn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return btn
    }()
    
    private lazy var vStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [titleLabel, idLabel])
        st.axis = .vertical
        return st
    }()
    
    private lazy var hStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [vStack, isDoneSwitch,  deleteButton])
        st.axis = .horizontal
        st.spacing = 8
        return st
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print(#fileID, #function, #line, "prepareForReuse() - cellData.id: \(cellData?.id ?? 0)")
        
        self.disposeBag = DisposeBag()
    }
    
    // 원래는 awakefromnib을 타지만 코드로 UI를 진행한다면 awakefromnib을 타지 않는다.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        /// 부모의 로직을 싱행시키는 의미
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
        constraints()
        
        /*
        // MARK: - 클로저로 터트리는 방식
        isDoneSwitch.addTarget(self,
                               action: #selector(handleIsDone),
                               for: .valueChanged)
         */
        
        /*
        // MARK: - Rx방식
        isDoneSwitch.rx.isOn
            .debug("[Debug]: Switch")
            .bind(onNext: { [weak self] isOn in
                guard let self = self, let id = self.cellData?.id else { return }
                self.isDoneChange?(id, isOn)
            })
            .disposed(by: disposeBag)
         */
        
        // 이걸 vc에서 구독하면된다 -> 그러면 스크롤해서 토글이 사라지는 현상 해결됨
        updateActionObservable = isDoneSwitch
            .rx
            .controlEvent(.valueChanged) // rx cocoa에서 만들어둔 이벤트 버그 생기면 uicontrol을 controlevent로받자
            .debug("[Debug]: isDoneSwitch")
            .compactMap ({ [weak self] _ -> (id: Int, newValue: Bool)? in
                guard let self = self,
                        let unWrappediId = self.cellData?.id else { return nil }
                return (id: unWrappediId, newValue: self.isDoneSwitch.isOn)
            })
        
        deleteButton.rx.tap
            .debug("[Debug]: delete")
            .bind(onNext: { [weak self] _ in
                guard let self = self, let id = self.cellData?.id else { return }
                self.deleteAction?(id)
            })
            .disposed(by: disposeBag)
        
        // MARK: - Rx방식2(클로저로 전달안하고 싶으면 옵저버블 사용하면 된다)
        deleteActionObservable = deleteButton.rx.tap.debug("deletedBtn")
            .compactMap { [weak self] _ in
                self?.cellData?.id
            }
        
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
    
    @objc func handleIsDone(_ sender: UISwitch) {
        print(#fileID, #function, #line, "- id: \(cellData?.id ?? 0), sendar: \(sender.isOn)")
        guard let id = self.cellData?.id else { return }
        isDoneChange?(id, sender.isOn)
    }
    
    @objc func removeBtn(_ sender: UIButton) {
        guard let id = self.cellData?.id else { return }
        deleteAction?(id)
    }
}

extension TodoCell {
    func configure(with todo: Todo) {
        self.cellData = todo
        titleLabel.text = todo.title
        idLabel.text = "ID: \(todo.id)"
        isDoneSwitch.isOn = todo.isDone
    }
}






