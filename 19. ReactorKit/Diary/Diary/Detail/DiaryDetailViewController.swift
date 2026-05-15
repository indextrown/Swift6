//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 김동현 on 5/15/26.
//

import UIKit
import ReactorKit
import SnapKit
import RxCocoa

final class DiaryDetailViewController: UIViewController, View {
    
    var disposeBag = DisposeBag()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    init(reactor: DiaryDetailReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
    }
    
    func setUI() {
        view.backgroundColor = .white
        navigationItem.setRightBarButtonItems([
            .init(customView: editButton),
            .init(customView: deleteButton)
        ], animated: true)
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(contentLabel)
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func bind(reactor: DiaryDetailReactor) {
        
        // 진입 시점에 액션 호출
        reactor.action.onNext(.getDiary)
        
        EventBus.shared.asObservable()
            .bind { event in
                if case .refreshDetail = event {
                    reactor.action.onNext(.getDiary)
                }
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.diary }
            .compactMap { $0 }
            .withUnretained(self)
            .bind { vc, diary in
                vc.titleLabel.text = diary.title
                vc.contentLabel.text = diary.content
                vc.dateLabel.text = vc.getDateString(date: diary.createdDate)
            }.disposed(by: disposeBag)
        
        reactor.pulse(\.$deleteSuccess)
            .filter { $0 } // true인 경우만 리턴
            .withUnretained(self)
            .bind { vc, _ in
                EventBus.shared.publish(event: .refreshList)
                
                vc.showOnButtonAlert(
                    title: "삭제 완료",
                    message: "삭제가 완료되었습니다.") {
                        vc.navigationController?.popViewController(animated: true)
                    }
            }.disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .withUnretained(self)
            .bind { vc, error in
                vc.showOnButtonAlert(
                    title: "에러",
                    message: error.description, action: nil)
            }.disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.showTwoButtonAlert(
                    title: "삭제",
                    message: "정말로 삭제하시겠습니까?") {
                        reactor.action.onNext(.delete)
                    }
            }.disposed(by: disposeBag)
        
        editButton.rx.tap // 옵저버블 값을 latestFrom을 통해 값을 치환
            .withLatestFrom(reactor.state.map { $0.diary })
            .compactMap { $0 }
            .withUnretained(self)
            .bind { vc, diary in
                vc.pushWriteVC(diary: diary)
            }.disposed(by: disposeBag)
    }
}


extension DiaryDetailViewController {
    private func getDateString(date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let component = calendar.dateComponents(
            [.month, .weekOfYear, .day, .hour, .minute], from: date, to: now
        )
        if let month = component.month, month > 0 {
            return "\(month) 개월 전"
        } else if let week = component.weekOfYear, week > 0 {
            return "\(week) 주 전"
        } else if let day = component.day, day > 0 {
            return "\(day) 일 전"
        } else if let hour = component.hour, hour > 0 {
            return "\(hour) 시간 전"
        } else if let minute = component.minute, minute > 0 {
            return "\(minute) 분 전"
        } else {
            return "방금 전"
        }
    }
    
    private func showTwoButtonAlert(
        title: String,
        message: String,
        action: @escaping (() -> Void)
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(
            title: "확인", style: .default) { _ in
                action()
            }
        alert.addAction(confirmAction)
        alert.addAction(.init(title: "취소", style: .default))
        navigationController?.present(alert, animated: false)
    }
    
    private func showOnButtonAlert(
        title: String,
        message: String,
        action: (() -> Void)?
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(
            title: "확인", style: .default) { _ in
                action?()
            }
        alert.addAction(confirmAction)
        navigationController?.present(alert, animated: false)
    }
    
    private func pushWriteVC(diary: DiaryItem) {
        guard let coreData = reactor?.coreData else { return }
        let writeReactor = DiaryWriteViewReactor(
            initialState: .init(type: .edit(id: diary.id), title: diary.title, content: diary.content),
            coreData: coreData
        )
        let writeVC = DiaryWriteViewController(reactor: writeReactor)
        navigationController?.pushViewController(writeVC, animated: true)
    }
}
