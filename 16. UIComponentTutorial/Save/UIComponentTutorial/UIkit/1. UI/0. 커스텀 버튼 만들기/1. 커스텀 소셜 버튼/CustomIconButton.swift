//
//  AlignedIconButton.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 7/27/25.
//

/*
 [iOS/UIKit] init(frame:)와 init(coder:)
 https://leeari95.tistory.com/63
 https://sarunw.com/posts/new-way-to-style-uibutton-in-ios15/#insets-%2F-padding
 */

import UIKit


/*
final class AlignedIconButton: UIButton {
    
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
        self.iconAlignment = iconAlign
        self.setTitle(title, for: .normal)
        self.backgroundColor = bgColor
        self.tintColor = fgColor
        self.layer.cornerRadius = radius
        self.setImage(image, for: .normal)
        self.padding = padding
    }
    
    // 2. 오토레이아웃을 걸거나 스택뷰라면 아이템들을 집어넣어서 레이아웃이 발동될 때
    // 버튼이 생성되고 나서 오토레이아웃으로 anchor를 걸기 때문에 layoutSubview가 찍힌다.
    override func layoutSubviews() {
        super.layoutSubviews()
        print(#fileID, #function, #line, "- ")
        
        // let imageWidth = imageView?.frame.width ?? 0
        
        // MARK: - 왼쪽 이미지 정렬
        /*
        contentHorizontalAlignment = .left
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        
        let availableWidth = availableSpace.width - imageEdgeInsets.right - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        
        let leftPadding = (availableWidth / 2) - (imageWidth / 2)
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: 0)
        contentEdgeInsets = padding
        // titleEdgeInsets = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
        // contentEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
         */
        
        // MARK: - 오른쪽 이미지 정렬
        /*
        semanticContentAttribute = .forceRightToLeft
        contentHorizontalAlignment = .right
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        
        let availableWidth = availableSpace.width - imageEdgeInsets.left - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        
        let rightPadding = (availableWidth / 2) - (imageWidth / 2)
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: rightPadding)
        contentEdgeInsets = padding
         */
        
        
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
extension AlignedIconButton {
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
 */

@available(iOS 15.0, *)
final class AlignedIconButton2: UIButton {

    // MARK: - 아이콘 정렬
    enum IconAlignment {
        case leading
        case trailing
    }
    
    // MARK: - 저장 속성
    private var iconAlignment: IconAlignment = .leading
    private var buttonTitle: String = "타이틀 없음"
    private var bgColor: UIColor = .systemBlue
    private var fgColor: UIColor = .white
    private var radius: CGFloat = 10
    private var image: UIImage? = nil
    private var padding: NSDirectionalEdgeInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)

    
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
                     font: UIFont = UIFont(name: "Pretendard-Light", size: 20)!,
                     bgColor: UIColor = .systemBlue,
                     fgColor: UIColor = .white,
                     radius: CGFloat = 10,
                     image: UIImage? = nil,
                     padding: NSDirectionalEdgeInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
    ) {
        self.init(type: .system)
        self.iconAlignment = iconAlign
        self.buttonTitle = title
        self.bgColor = bgColor
        self.fgColor = fgColor
        self.radius = radius
        self.image = image
        self.padding = padding

        configure()
    }
    
    
    private func configure() {
        var config = UIButton.Configuration.filled()
        config.title = buttonTitle
        config.image = image
        config.imagePadding = 10
        config.baseBackgroundColor = bgColor
        config.baseForegroundColor = fgColor
        config.contentInsets = padding
        config.cornerStyle = .fixed
        config.background.cornerRadius = radius
        config.titleAlignment = .center
        
        switch iconAlignment {
        case .leading:
            config.imagePlacement = .leading
        case .trailing:
            config.imagePlacement = .trailing
        }
        self.configuration = config
    }
}



@available(iOS 15.0, *)
final class AlignedIconButton3: UIButton {

    enum IconAlignment {
        case leading
        case trailing
    }

    private var iconAlignment: IconAlignment = .leading
    private var padding: NSDirectionalEdgeInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)

    // ✅ designated initializer로 변경
    init(
        iconAlign: IconAlignment = .leading,
        title: String = "타이틀 없음",
        bgColor: UIColor = .systemBlue,
        fgColor: UIColor = .white,
        radius: UIButton.Configuration.CornerStyle = .medium,
        image: UIImage? = nil,
        padding: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
    ) {
        super.init(frame: .zero) // ✅ 안전한 초기화 방법

        self.iconAlignment = iconAlign
        self.padding = padding

        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = image
        config.baseBackgroundColor = bgColor
        config.baseForegroundColor = fgColor
        config.cornerStyle = radius
        config.contentInsets = padding
        config.imagePadding = 8
        config.imagePlacement = (iconAlign == .leading) ? .leading : .trailing

        self.configuration = config
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



@available(iOS 15.0, *)
final class AlignedIconButton4: UIControl {

    enum IconAlignment {
        case leading
        case trailing
    }

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    private let padding: UIEdgeInsets
    private let iconAlignment: IconAlignment
    private let radius: CGFloat
    private let bgColor: UIColor
    private let fgColor: UIColor
    private let title: String

    init(
        iconAlign: IconAlignment = .leading,
        title: String = "타이틀 없음",
        bgColor: UIColor = .systemBlue,
        fgColor: UIColor = .white,
        radius: CGFloat = 10,
        image: UIImage? = nil,
        padding: UIEdgeInsets = .init(top: 10, left: 20, bottom: 10, right: 20)
    ) {
        self.iconAlignment = iconAlign
        self.padding = padding
        self.radius = radius
        self.bgColor = bgColor
        self.fgColor = fgColor
        self.title = title

        super.init(frame: .zero)
        self.backgroundColor = bgColor
        self.layer.cornerRadius = radius
        self.clipsToBounds = true

        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = fgColor

        titleLabel.text = title
        titleLabel.textColor = fgColor
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 16)

        addSubview(imageView)
        addSubview(titleLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // let contentWidth = bounds.width - padding.left - padding.right
        let contentHeight = bounds.height - padding.top - padding.bottom

        let imageSize = CGSize(width: contentHeight, height: contentHeight)
        let titleSize = titleLabel.intrinsicContentSize

        let centerY = bounds.midY

        switch iconAlignment {
        case .leading:
            imageView.frame = CGRect(
                x: padding.left,
                y: centerY - imageSize.height / 2,
                width: imageSize.width,
                height: imageSize.height
            )
            titleLabel.frame = CGRect(
                x: (bounds.width - titleSize.width) / 2,
                y: centerY - titleSize.height / 2,
                width: titleSize.width,
                height: titleSize.height
            )

        case .trailing:
            imageView.frame = CGRect(
                x: bounds.width - padding.right - imageSize.width,
                y: centerY - imageSize.height / 2,
                width: imageSize.width,
                height: imageSize.height
            )
            titleLabel.frame = CGRect(
                x: (bounds.width - titleSize.width) / 2,
                y: centerY - titleSize.height / 2,
                width: titleSize.width,
                height: titleSize.height
            )
        }
    }
}


//@available(iOS 15.0, *)
final class CustomIconButton: UIButton {

    private var padding: NSDirectionalEdgeInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)

    // ✅ designated initializer로 변경
    init(
        iconAlign: NSDirectionalRectEdge = .leading,
        title: String = "타이틀 없음",
        font: UIFont = UIFont.pretendard(.regular, size: 18),
        bgColor: UIColor = .systemBlue,
        fgColor: UIColor = .white,
        radius: UIButton.Configuration.CornerStyle = .medium,
        image: UIImage? = nil,
        padding: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
    ) {
        super.init(frame: .zero) // ✅ 안전한 초기화 방법
        self.padding = padding
        
        // 폰트
        if #available(iOS 15.0, *) {
            // iOS 15 이상: Configuration 기반 폰트 설정
            var config = UIButton.Configuration.filled()
            config.title = title
            config.image = image
            config.baseBackgroundColor = bgColor
            config.baseForegroundColor = fgColor
            config.cornerStyle = radius
            config.contentInsets = padding
            config.imagePadding = 8
            config.imagePlacement = iconAlign
            
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
                var updated = attributes
                updated.font = font
                return updated
            }
            self.configuration = config
        } else {
            // iOS 15 미만: titleLabel을 통해 직접 폰트 설정
            setTitle(title, for: .normal)
            setTitleColor(fgColor, for: .normal)
            backgroundColor = bgColor
            titleLabel?.font = font
            contentEdgeInsets = UIEdgeInsets(
                top: padding.top,
                left: padding.leading,
                bottom: padding.bottom,
                right: padding.trailing
            )
            layer.cornerRadius = 8 // or convert from `radius`
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//#if DEBUG
//import SwiftUI
//
//struct CustomViewTest_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomViewTest()
//            .getPreview()
//            .ignoresSafeArea()
//    }
//}
//#endif
