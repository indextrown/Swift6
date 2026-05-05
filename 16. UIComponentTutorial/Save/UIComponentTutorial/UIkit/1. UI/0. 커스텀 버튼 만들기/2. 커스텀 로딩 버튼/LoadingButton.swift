//
//  LoadingButton.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 7/28/25.
//

import UIKit

final class LoadingButton: UIButton {
    
    // MARK: - 로딩 상태
    enum LoadingState {
        case normal
        case loading
    }
    var indicator: UIActivityIndicatorView?
    var loadingState: LoadingState = .normal {
        // Property Observer: 현재 값이 변경되면 발동, 로딩보여주는ui는 메인 스레드에서 작업 필요
        didSet {
            DispatchQueue.main.async {
                switch self.loadingState {
                case .normal: self.hideLoading()
                case .loading: self.showLoading()
                }
            }
        }
    }
    
    // MARK: - 아이콘 정렬
    enum IconAlignment {
        case leading
        case trailing
    }
    var padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var iconAlignment: IconAlignment = .leading
    
    
    
    // 1. 버튼이 메모리 공간에 올라가면 여기 먼저 호출됨
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(#fileID, #function, #line, "- ")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 3. 기존 생성자에서 추가적으로 매개변수를 넣고싶을 때 사용, 반드시 다른 생성자를 호출해야 한다
    convenience init(iconAlign: IconAlignment = .leading,
                     title: String = "타이틀 없음",
                     bgColor: UIColor = .systemBlue,
                     fgColor: UIColor = .white,
                     radius: CGFloat = 10,
                     image: UIImage? = nil,
                     padding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    ) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.backgroundColor = bgColor
        self.tintColor = fgColor
        self.layer.cornerRadius = radius
        self.setImage(image, for: .normal)
        self.padding = padding
        self.iconAlignment = iconAlign
    }
    
    // 2. 오토레이아웃을 걸거나 스택뷰라면 아이템들을 집어넣어서 레이아웃이 발동될 때
    // 버튼이 생성되고 나서 오토레이아웃으로 anchor를 걸기 때문에 layoutSubview가 찍힌다.
    override func layoutSubviews() {
        super.layoutSubviews()
        print(#fileID, #function, #line, "- ")
        
        switch iconAlignment {
        case .leading:
            alignIconLeading()
        case .trailing:
            alignIconTrailing()
        }
        
        contentEdgeInsets = padding
    }
}

// MARK: - 아이콘 정렬 관련
extension LoadingButton {
    // MARK: - 왼쪽 정렬
    private func alignIconLeading() {
        let imageWidth = imageView?.frame.width ?? 0
        contentHorizontalAlignment = .left
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        
        let availableWidth = availableSpace.width - imageEdgeInsets.right - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        
        let leftPadding = (availableWidth / 2) - (imageWidth / 2)
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: 0)
    }
    
    // MARK: - 오른쪽 정렬
    private func alignIconTrailing() {
        let imageWidth = imageView?.frame.width ?? 0
        semanticContentAttribute = .forceRightToLeft
        contentHorizontalAlignment = .right
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        
        let availableWidth = availableSpace.width - imageEdgeInsets.left - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        
        let rightPadding = (availableWidth / 2) - (imageWidth / 2)
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: rightPadding)
    }
}

// MARK: - 로딩 관련
extension LoadingButton {
    
    /// 로딩 보여주기
    private func showLoading() {
        
        self.isUserInteractionEnabled = false
        
        if indicator == nil {
            let myIndicator = UIActivityIndicatorView(style: .medium).then {
                $0.color = .white
                $0.startAnimating()
            }
            self.addSubview(myIndicator)
            myIndicator.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            self.indicator = myIndicator
        }
        
        self.titleLabel?.alpha = 0
        self.imageView?.alpha = 0
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut) {
            self.titleLabel?.alpha = 0
            self.imageView?.alpha = 0
            self.indicator?.alpha = 1
        }
    }
    
    /// 로딩 숨기기
    private func hideLoading() {
        
        self.isUserInteractionEnabled = true
        
        UIView.transition(with: self, duration: 0.2, options: .curveEaseIn) {
            self.titleLabel?.alpha = 1
            self.imageView?.alpha = 1
            self.indicator?.alpha = 0
        }
    }
}
