//
//  TabButtonView.swift
//  MVVM+CleanArchitecture+Rx
//
//  Created by 김동현 on 4/5/25.
//

import UIKit
import RxSwift
import RxCocoa

final class TabButtonView: UIStackView {
    private var tabList: [TabButtonType]
    private let disposeBag = DisposeBag()
    
    // Relay를 쓰는 이유: UI적인 이벤트 타입이라서 Relay만 써도 된다
    public let selectedType: BehaviorRelay<TabButtonType?>
    
    init(tabList: [TabButtonType]) {
        self.tabList = tabList
        self.selectedType = BehaviorRelay(value: tabList.first)
        super.init(frame: .zero)
        alignment = .fill
        distribution = .fillEqually
        addButton()
        
        // 앱실행시 초기 첫 탭 자동 선택
        (arrangedSubviews.first as? UIButton)?.isSelected = true
        
        // 선택한 값을 VC에 전달하는 2가지 방법
        
        // 1. 탭버튼 뷰에서 Callback함수 만들어서 사용하는법
        
        // 2. 이벤트를 VC에서 구독해서 활용하는 방법 -> RX스타일
    
        
    }
    
    private func addButton() {
        tabList.forEach { tabType in
            let button = TabButton(type: tabType)
            
            // 버튼 눌릴 때 선택되는 UI 호출, 해당하는 선택된 타입을 VC에 전달하여 VC가 그에 맞는 UI 리스트를 보여준다
            button.rx.tap.bind { [weak self] in
                self?.arrangedSubviews.forEach { view in
                    (view as? UIButton)?.isSelected = false
                }
                self?.selectedType.accept(tabType)
                button.isSelected = true
            }.disposed(by: disposeBag) // 탭버튼뷰가 필요없어질때 -> VC가 메모리에서 해제될때 disposeBag이 호출되고 버려짐(메모리 관리를 위함)
            
            // TabButtonView가 스택뷰이므로 스택뷰에 버튼을 넣어준다
            addArrangedSubview(button)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class TabButton: UIButton {
    private let type: TabButtonType
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .systemCyan
            } else {
                backgroundColor = .white
            }
        }
    }
    
    init(type: TabButtonType) {
        self.type = type
        super.init(frame: .zero)
        setTitle(type.rawValue, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        setTitleColor(.black, for: .normal)
        setTitleColor(.white, for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
