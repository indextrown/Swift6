//
//  ChatTextViewController.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 5/19/25.
//
// https://velog.io/@s_sub/새싹-iOS-26주차
// https://ios-development.tistory.com/1432
// https://babbab2.tistory.com/171
// https://velog.io/@s_sub/Swift-생성자


/*
 https://developer.apple.com/documentation/uikit/uitextview
 [UITextview]
 - 스크롤 가능한 여러 줄의 텍스트 영역
 - 텍스트 표시 & 편집 지원
 - 큰 텍스트 문서의 본문 표시와 같은 여러 줄 텍스트를 표시
 
 [지정 생성자 designated init()]
 - 일반적인 생성자
 
 [편의 생성자 convenience init()]
 - 다른 생성자를 호출하는 생성자
 
 [필수 생성자 required init()]
 - 필수 생성자로, 슈퍼 클래스에서 정의해둘 경우 서브 클래스가 슈퍼 클래스의 생성자를 상속받지 않는 한
   서브 클래스에서 반드시 구현해주어야 한다.
 
 
 [Uikit 두가지 뷰 만드는 방법]
 - 1. 코드로 직접 만들기 init(frame: )
 - 2. 스토리보드나 XIB파일로 만들기 init(coder: )
 
 [required init?(coder: )]
 - 스토리보드(XIB포함)에서 객체를 생성할 때 호출하는 트굿한 생성자이다. 슈퍼클래스 UIView, UIViewController에 정의되어 있어
   서브클래스에서 반드시 구현해야 한다.
 - Uikit의 기본 클래스들은 init(coder: )를 이미 가지고 있다.
   즉 UIView를 상속받는 서브클래스를 만든다면 서브 클래스도 반드시 이 생성자를 구현해야 한다
 - 스토리보드에서 이 클래스를 쓰려고 할 때 자동으로 호출될 수 있는 생성자이지만, 코드베이스로 작성시 혹시라도 누군가가 실수로 스토리보드에서 이 클래스를 사용하면 앱이 죽게(fatalError)해서 알려주기 위한 장치이다.
 
 [정리]
 - required init?(coder: )는 슈퍼클래스에서 가지고 있으면 서브 클래스도 무조건 구현해야한다(안하면 에러
 - 스토리보드를 안쓴다면 강제로 크래시 내버리는 코드를 쓰겠다는 의미이다.

 class UIView {
    init(frame: CGRect)
    required init?(coder: NSCoder)
 }
 
 class MyView: UIView {
 
     override init(frame: CGRect) {
         super.init(frame: frame)
     }

     // 이걸 안 쓰면 컴파일 에러!
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
 }
 
 */


import UIKit

// MARK: - CustomView Template
class BaseView: UIView {
    
    // 코드로 초기화할 때 실행되는 생성자
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
        constraints()
    }
    
    // 스토리보드/XIB 사용 금지
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI 구성용 함수 (서브클래스에서 override 가능)
    func makeUI() {
        
    }
    
    // 제약조건 설정용 함수 (서브클래스에서 override 가능)/
    func constraints() {
        
    }
}

// MARK: - 텍스트뷰
final class ChattingTextView: UITextView {
    
    /// placeholder label
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "메시지를 입력하세요"
        label.textColor = .placeholderText
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()
    
    /// 지정된 텍스트 컨테이너로 새 텍스트 보기를 만든다
    /// - Parameters:
    ///   - frame: 텍스트 보기의 프레임 사각형
    ///   - textContainer: 수신자에 사용할 텍스트 컨테이너
    ///   - return: 초기화된 텍스트 보기
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        makeUI()
        constraints()
    }
    
    /// 스토리보드 금지용 안전장치
    /// 코드베이스로 작성시 혹시라도 누군가가 실수로 스토리보드에서 이 클래스를 사용하면 앱이 죽게(fatalError)해서 알려주기 위한 장치
    /// 서브 클래스에서 모든 프로퍼티가 기본 값을 가지고 있어서 지정 생성자를 따로 작성하지 않으면 부모 클래스의 지정 생성자를 모두 상속받는다
    /// 지정 생성자를 직접 서브클래스에서 작성한다면 required init()이 필수적이다
    /// - Parameter coder: storyboard나 xib로 구현한 UI는 xml 형태로 저장하는데, 이 xml형태를 화면으로 가져올 때 사용되는 것
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeUI() {
        /// 기본 스타일
        font = .systemFont(ofSize: 16)
        
        /// 모서리 둥글게 설정
        layer.cornerRadius = 12
        clipsToBounds = true
        
        /// 배경 제거
        backgroundColor = .clear
        
        /// 테두리 색상
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor /// cgColor: UIColor -> CoreGraphics에서 사용 가능한 색상 객체
        
        // ✅ 커서가 너무 위로 붙는 문제 해결
        textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        /// 텍스트가 입력되면 placeholder 숨기기
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }
    
    private func constraints() {
        addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // 위치
            placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
        ])
    }
    
    /// 텍스트 변경시 placeholder 숨김
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}

// MARK: - 텍스트뷰 + 버튼뷰
final class ChattingView: BaseView {
    // 동적 높이
    private var heightConstraint: NSLayoutConstraint?
    
    // 텍스트뷰
    private let chattingTextView: ChattingTextView = {
        let view = ChattingTextView()
        view.isScrollEnabled = false
        return view
    }()
    
    // 버튼
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전송", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [chattingTextView, sendButton])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .bottom
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func makeUI() {
        chattingTextView.delegate = self
        addSubview(hStack)
    }
    
    override func constraints() {
        
        // 높이 초기값
        let initialHeight = (chattingTextView.font?.lineHeight ?? 16)
              + chattingTextView.textContainerInset.top
              + chattingTextView.textContainerInset.bottom

        // 동적높이 = 텍스트뷰높이 = 초기값
        heightConstraint = chattingTextView.heightAnchor.constraint(equalToConstant: initialHeight)
        heightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            // sendButton 고정 크기(가로: 고정, 세로: 텍스트뷰 높이 초기값)
            sendButton.widthAnchor.constraint(equalToConstant: 60),
            sendButton.heightAnchor.constraint(equalToConstant: initialHeight),
        ])
    }
}

extension ChattingView {
    var text: String {
        return chattingTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func clearInput() {
        chattingTextView.text = ""
        chattingTextView.delegate?.textViewDidChange?(chattingTextView)
    }
    
//    /// 입력창의 폰트 높이 + 위아래 패딩을 합산한 예상 높이
//    var estimatedHeight: CGFloat {
//        (chattingTextView.font?.lineHeight ?? 16)
//        + chattingTextView.textContainerInset.top
//        + chattingTextView.textContainerInset.bottom
//    }
}

extension ChattingView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: self.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        // estimatedSize
        // 1줄일 때 31.6
        // 2줄일 때 47.3
        // 3줄일 때 62.6
        
        if estimatedSize.height > 130 {
            textView.isScrollEnabled = true
            return
        } else {
            textView.isScrollEnabled = false

            // 레이아웃 중 height 수정
            textView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
}

final class ChatTextViewController: UIViewController {

    private lazy var chattingView: ChattingView = {
        let view = ChattingView()
        view.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        constraints()
    }
    
    private func makeUI() {
        view.backgroundColor = .white
    }

    private func constraints() {
        view.addSubview(chattingView)
        chattingView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // 위치
            chattingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -160),
            chattingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // 크기
            chattingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }
    
    @objc func sendButtonTapped() {
        let message = chattingView.text
        chattingView.clearInput()
        print("\(message) 전송")
    }
}

#Preview {
    ChatTextViewController()
}
