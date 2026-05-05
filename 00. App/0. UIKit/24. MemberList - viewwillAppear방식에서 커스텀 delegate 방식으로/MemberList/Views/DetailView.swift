//
//  DetailView.swift
//  MemberList
//
//  Created by 김동현 on 3/10/25.
//

/*
 let
 - 불변성: 한번 초기화되어 값이 변경되지 않는 상수 선언시 사용
 - 즉시 초기화: 인스턴스 생성될 때 바로 값이 할당된다
 - 메모리 효율: 값이 한 번만 할당되고 변하지 않아서 메모리, 스레드 안전성 측면에서 이점
 - mainImageView나 memberLabel과 같이, 인스턴스 생성 시 바로 필요한 값이나 UI요소는 let을 사용하여 초기화
 
 lazy var
 - 지연 초기화(lazy initialization): 프로퍼티에 접근하는 시점까지 초기화를 미룬다. 즉 해당 프로퍼티가 실제 사용될 때 초기화되므로, 불필요한 리소스 소모를 줄일 수 있다
 - 자기 참조 가능: 인스턴스가 자신(self)을 참조해야 하거나, 다른 프로퍼티에 의존하는 초기화 로직이 필요한 경우 유용
 - 초기화 비용: 초기화 비용이 크거나 초기화가 꼭 필요하지 않을 때 사용한다
 - imageContainerView는 내부에 mainImageView를 추가하고 있는데, 이때 다른 프로퍼티에 접근해야 할 필요가 있거나 초기화 순서를 고려할 때 lazy var로 선언하여 지연 초기화
 
 https://seungchan.tistory.com/entry/Swift-SnapKit에서-lazy-var-와-let
 
 */

import UIKit

final class DetailView: UIView {
    
    var member: Member? {
        didSet {
            guard var member = member else {
                // 멤버가 없으면 (즉 새로운 멤버를 추가할때의 상황
                // 멤버가 없으면 버튼을 "Save" 라고 세팅
                saveButton.setTitle("Save", for: .normal)
                memberIdTextField.text = "\(Member.memberNumbers)"
                return
            }
            
            // 멤버가 있으면(member 저장속성이 변하면)
            mainImageView.image = member.memberImage
            memberIdTextField.text = "\(member.memberId)"
            nameTextField.text = member.name
            phoneNumberTextField.text = member.phone
            addressTextField.text = member.address
            
            // 나이항목의 구현
            ageTextField.text = member.age != nil ? "\(member.age!)" : ""
            
            /* 나이항목(옵셔널 정수)
            guard let age = member.age else {
                ageTextField.text = ""
                return
            }
            ageTextField.text = "\(age)"
             */
        }
    }
    
    // MARK: - View
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 정렬을 깔끔하게 하기 위한 컨테이너뷰(이미지 뷰를 담는 컨테이너뷰)
    lazy var imageContainerView: UIView = {
        let view = UIView()
        view.addSubview(mainImageView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
     
    let memberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "멤버번호:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let memberIdTextField: UITextField = {
        let tf = UITextField()
        tf.frame.size.height = 22
        tf.textColor = .black
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var memberIdStackView: UIStackView = {
        let stView = UIStackView(arrangedSubviews: [memberLabel, memberIdTextField])
        stView.spacing = 5
        stView.axis = .horizontal
        stView.distribution = .fill
        stView.alignment = .fill
        stView.translatesAutoresizingMaskIntoConstraints = false
        return stView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "이름"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.frame.size.height = 22
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var nameStackView: UIStackView = {
        let stView = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
        stView.spacing = 5
        stView.axis = .horizontal
        stView.distribution = .fill
        stView.alignment = .fill
        stView.translatesAutoresizingMaskIntoConstraints = false
        return stView
    }()

    let ageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "나이"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ageTextField: UITextField = {
        let tf = UITextField()
        tf.frame.size.height = 22
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var ageStackView: UIStackView = {
        let stView = UIStackView(arrangedSubviews: [ageLabel, ageTextField])
        stView.spacing = 5
        stView.axis = .horizontal
        stView.distribution = .fill
        stView.alignment = .fill
        stView.translatesAutoresizingMaskIntoConstraints = false
        return stView
    }()
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "전화번호"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let phoneNumberTextField: UITextField = {
        let tf = UITextField()
        tf.frame.size.height = 22
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var phoneNumberStackView: UIStackView = {
        let stView = UIStackView(arrangedSubviews: [phoneNumberLabel, phoneNumberTextField])
        stView.spacing = 5
        stView.axis = .horizontal
        stView.distribution = .fill
        stView.alignment = .fill
        stView.translatesAutoresizingMaskIntoConstraints = false
        return stView
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "전화번호"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addressTextField: UITextField = {
        let tf = UITextField()
        tf.frame.size.height = 22
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var addressStackView: UIStackView = {
        let stView = UIStackView(arrangedSubviews: [addressLabel, addressTextField])
        stView.spacing = 5
        stView.axis = .horizontal
        stView.distribution = .fill
        stView.alignment = .fill
        stView.translatesAutoresizingMaskIntoConstraints = false
        return stView
    }()

    let saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemBlue
        button.setTitle("Update", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.frame.size.height = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stView = UIStackView(arrangedSubviews: [
            imageContainerView,
            memberIdStackView,
            nameStackView,
            ageStackView,
            phoneNumberStackView,
            addressStackView,
            saveButton
        ])
        stView.spacing = 10
        stView.axis = .vertical
        stView.distribution = .fill
        stView.alignment = .fill
        stView.translatesAutoresizingMaskIntoConstraints = false
        return stView
    }()
    
    // 레이블 넓이 지정을 위한 속성
    let labelWidth: CGFloat = 70
    
    // 애니메이션을 위한 속성 선언
    var stackViewTopConstraint: NSLayoutConstraint!
    
    // 뷰를 만드는 생성자(뷰 생성시 크기와 위치 필요)
    // 지정생성자 구현시 반드시 상위에서 구현된 필수생성자 구현해야함
    override init(frame: CGRect) {
        super.init(frame: frame)
        // view?.backgroundColor = .white
        // 이 클래스 자체가 view라서 즉 self로 접근 가능
        self.backgroundColor = .white
        
        setupStackView()
        setupNotification()
        setUpMemberIdTextField()
    }
    
    // 필수생성자
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // view 추가
    func setupStackView() {
        self.addSubview(stackView)
    }
    
    // notification
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpAction), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownAction), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setUpMemberIdTextField() {
        memberIdTextField.delegate = self
    }
    
    // 오토레이아웃 설정 1
    override func updateConstraints() {
        setConstraints()
        super.updateConstraints()
    }
    
    // 오토레이아웃 설정 2
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            // mainImageView 가로 x 세로 150
            mainImageView.widthAnchor.constraint(equalToConstant: 150),
            mainImageView.heightAnchor.constraint(equalToConstant: 150),
            
            // mainImageView의 중심을 imageContainerView의 중심으로 지정
            mainImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            // imageContainerView의 높이 150
            imageContainerView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            // 각 레이블의 넓이 지정
            memberLabel.widthAnchor.constraint(equalToConstant: labelWidth),
            nameLabel.widthAnchor.constraint(equalToConstant: labelWidth),
            ageLabel.widthAnchor.constraint(equalToConstant: labelWidth),
            phoneNumberLabel.widthAnchor.constraint(equalToConstant: labelWidth),
            addressLabel.widthAnchor.constraint(equalToConstant: labelWidth)
        ])
        
        stackViewTopConstraint = stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10)
        
        NSLayoutConstraint.activate([
            stackViewTopConstraint,
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
    
    
    // MARK: - 오토레이아웃 추가 설정
    @objc func moveUpAction() {
        stackViewTopConstraint.constant = -20
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    @objc func moveDownAction() {
        stackViewTopConstraint.constant = 10
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    // 화면터치시 키보드 내려가도록
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - 텍스트필드 델리게이트 구현
extension DetailView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 멤버 아이디는 수정 못하도록 설정(멤버아이디의 텍스트필드는 입력 안되도록 설정하자)
        if textField == memberIdTextField {
            return false
        }
        
        // 나머지 텍스트필드는 관계없이 설정 가능
        return true
    }
}
