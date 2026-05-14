//
//  DiaryListViewController.swift
//  Diary
//
//  Created by 김동현 on 5/7/26.
//
// https://github.com/RxSwiftCommunity/RxDataSources#why
// https://eunjin3786.tistory.com/29
// https://velog.io/@honghoker/RxSwift-Rx%EB%A1%9C-%EB%8B%A8%EC%9D%BC-Section-TableView%EB%A5%BC-%EA%B5%AC%ED%98%84%ED%95%98%EB%8A%94-%EB%B0%A9%EB%B2%95-setDelegate

import UIKit
import RxSwift
import RxCocoa // UI에 대한 이벤트를 쉽게 연결하는 기능 제공
import SnapKit
import ReactorKit
import CoreData

class DiaryListViewController: UIViewController, View {
    
    var disposeBag = DisposeBag()
    
    private let writeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        return button
    }() // 클로저를 즉시 실행하면 “실행 결과(return 값)”의 타입이 최종 값 타입이 된다
    
    private let modeButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let textField = {
        let tf = UITextField()
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 8
        return tf
    }()
    
    private let tableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.contentInset = .init(
            top: 16, left: 0, bottom: 0, right: 16
        )
        tableView.keyboardDismissMode = .onDrag
        tableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.id)
        return tableView
    }()
    
    private let deleteButton = {
        let button = UIButton()
        button.setTitle("삭제하기", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.isHidden = true
        return button
    }()
    
    init(reactor: DiaryListViewReactor) {
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
    
    private func setUI() {
        title = "다이어리"
        view.backgroundColor = .white
        navigationItem.setRightBarButtonItems([
            UIBarButtonItem(customView: writeButton),
            UIBarButtonItem(customView: modeButton),
        ],
        animated: true)
        
        view.addSubview(textField)
        view.addSubview(tableView)
        view.addSubview(textField)
        view.addSubview(deleteButton)
    }
    
    private func setConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(deleteButton.snp.top)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
    }

    func bind(reactor: DiaryListViewReactor) {
        
        // 강의 방식
        EventBus.shared.asObservable()
            .bind { event in
                if case .refreshList = event {
                    reactor.action.onNext(.refresh)
                }
            }.disposed(by: disposeBag)
        
        // 내 방식
        /*
        EventBus.shared.asObservable()
            .filter { $0 == .refreshList }
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
         */
        
        reactor.state
            .map { $0.cellDataList }
            .distinctUntilChanged()
            .bind(to: tableView.rx.items) { tableView, _, cellData in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellData.cellId) as? DiaryListCell else {
                    return UITableViewCell()
                }
                cell.apply(cellData: cellData)
                return cell
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.listMode }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { vc, mode in
                switch mode {
                case .normal:
                    vc.modeButton.setTitle("삭제", for: .normal)
                    vc.deleteButton.isHidden = true
                case .delete:
                    vc.modeButton.setTitle("완료", for: .normal)
                    vc.deleteButton.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$deleteSuccess)
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .withUnretained(self)
            .bind { vc, error in
                let alert = UIAlertController(
                    title: "에러",
                    message: error.description,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction.init(title: "확인", style: .default))
                vc.navigationController?.present(alert, animated: true)
            }.disposed(by: disposeBag)
        
        // mode에 따라 기능 달라짐,
        // 삭제: 삭제할 아이템 선택
        tableView.rx.modelSelected(DiaryListCellData.self)
            .filter { _ in return reactor.currentState.listMode == .delete }
            .map { Reactor.Action.selectItem(id: $0.diary.id) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
            // 이것도 가능하긴 함
//            .bind { cellData in
//                reactor.action.onNext(.selectItem(id: cellData.diary.id))
//            }

        // 일반: 상세로 이동
//        tableView.rx.modelSelected(DiaryListCellData.self)
//            .filter { _ in
//                return reactor.currentState.listMode == .normal
//            }
//            .bind { <#DiaryListCellData#> in
//
//            }
        
        writeButton.rx.tap
            .bind { [weak self] in
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let viewContext = appDelegate.persistentContainer.viewContext
                
                let writeVC = DiaryViewController(reactor: DiaryWriteViewReactor(
                    initialState: .init(),
                    coreData: DiaryCoreData(viewContext: viewContext))
                )
                self?.navigationController?.pushViewController(
                    writeVC,
                    animated: true
                )
            }.disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .map { Reactor.Action.delete }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // bind(onNext)말고 다른 방법
        // onNext보다 깔끔하고, 이벤트 흐름이 끊기지 않고 바로 전달되는 장점 있다.
        textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.query($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        modeButton.rx.tap
            .map { Reactor.Action.touchMode }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

