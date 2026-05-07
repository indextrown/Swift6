//
//  DiaryWriteViewController.swift
//  Diary
//
//  Created by 김동현 on 5/7/26.
//

/**
 .distinctUntilChanged()
 - bind 내 로직이 무거울때 연속 호출 방지
 - 값이 변할때만 호출
 
 bind(to:)
 - RxCocoa가 제공하는 Binder로 weak self 처리, MainThread보장, retainCycle문제없음
 */

import UIKit
import SnapKit
import ReactorKit
import RxCocoa

final class DiaryViewController: UIViewController, ReactorKit.View {
    // typealias Reactor = DiaryWriteViewReactor
    var disposeBag = DisposeBag()
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "제목"
        return label
    }()
    
    private let titleTextField = {
        let textField = UITextField()
        textField.borderStyle = .bezel
        return textField
    }()
    
    private let contentLabel = {
        let label = UILabel()
        label.text = "내용"
        return label
    }()
    
    private let contentTextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.borderWidth = 1
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    private let saveButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("저장", for: .normal)
        return button
    }()
    
    init(reactor: DiaryWriteViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(contentLabel)
        view.addSubview(contentTextView)
        view.addSubview(saveButton)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleTextField)
            make.bottom.equalTo(saveButton.snp.top).inset(-20)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(60)
        }
    }
    
    func bind(reactor: DiaryWriteViewReactor) {
        // TODO: - reactor state 바인딩
        titleTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind { title in
                reactor.action.onNext(.inputTitle(title))
            }.disposed(by: disposeBag)
        
        contentTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .bind { content in
                reactor.action.onNext(.inputContent(content))
            }.disposed(by: disposeBag)
        
        saveButton.rx.tap
            .bind {
                reactor.action.onNext(.save)
            }.disposed(by: disposeBag)
        
        reactor.state                   // Observable<State>
            .map { $0.isRequestEnable } // Observable<Bool>
            .distinctUntilChanged()     // Observable<Bool>
            // saveButton.rx.isEnabled == Binder<Bool> == ObserverType
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
            /*
             [강의 방식]
            .bind { [weak self] isRequestEnable in
                self?.saveButton.isEnabled = isRequestEnable
            }.disposed(by: disposeBag)
             */
        
        reactor.state
            .map { $0.saveSuccess }
            .filter { $0 } // true 인 경우에만 통과
            .bind { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.error } // 값이 있는 경우만 통과
            .bind { [weak self] error in
                let alert = UIAlertController(
                    title: "에러",
                    message: "\(error.description)",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.navigationController?.present(alert, animated: true)
            }.disposed(by: disposeBag)
    }
}
