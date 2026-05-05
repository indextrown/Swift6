//
//  ViewController.swift
//  MVVM+CleanArchitecture+Rx
//
//  Created by 김동현 on 4/3/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class UserListViewController: UIViewController {
    private let viewModel: UserListViewModelProtocol
    private let disposeBag = DisposeBag()
    private let saveFavorite = PublishRelay<UserListItem>()
    private let deleteFavorite = PublishRelay<Int>()
    private let fetchMore = PublishRelay<Void>()
    
    // 검색창
    private let searchTextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.cornerRadius = 6
        textField.placeholder = "검색어를 입력해 주세요"
        let image = UIImageView(image: .init(systemName: "magnifyingglass"))
        image.frame = .init(x: 0, y: 0, width: 20, height: 20)
        textField.leftView = image
        textField.leftViewMode = .always
        textField.tintColor = .black
        return textField
    }()
    private let tabButtonView = TabButtonView(tabList: [.api, .favorite])
    private let tableView = {
        let tableView = UITableView()
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.id)
        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: HeaderTableViewCell.id)
        return tableView
    }()
    
    
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        // view.backgroundColor = .systemPink
        
    }
    
    private func bindView() {
        /*
        tabButtonView.selectedType.bind { type in
            print("type: \(type)")
        }.disposed(by: disposeBag)
         */
    }
    
    private func bindViewModel() {
        let tabButtonType = tabButtonView.selectedType.compactMap { $0 }
        // orEmpty: 옵셔널 하지 않는 값만 남음, debounce: 입력이 많아지면 다무시하고 마지막만 사용하겠다.
        let query = searchTextField.rx.text.orEmpty.debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        let output = viewModel.transform(input: UserListViewModel.Input(tabButtonType: tabButtonType,
                                                           query: query,
                                                           saveFavorite: saveFavorite.asObservable(),
                                                           deleteFavorite: deleteFavorite.asObservable(),
                                                           fetchMore: fetchMore.asObservable()))
        
        output.cellData.bind(to: tableView.rx.items) { [weak self] tableView, index, cellData in
            // 2가지 타입을 한번에 처리
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellData.id) else { return UITableViewCell() }
            (cell as? UserListCellProtocol)?.apply(cellData: cellData)
            
            if let cell = cell as? UserTableViewCell, case let .user(user, isFavorite) = cellData {
                
                /*
                 VC의 disposeBag이 아니라 cell의 disposeBag를 해주는 이유
                 VC.disposeBag은 VC가 사라질떄까지 남아있지만 Cell은 계속 사라지고 생긴다.
                 
                 VC.disposeBag은 바인딩(리스너)이 계속 늘어난다. 바인딩 해제가 되야한다.
                 Cell.disposeBag을 하면 셀이 다시 그려질 때 바인딩를 해제하고 새로 바인딩하면 된다.(재사용되기때문에 overrite prepareForReuse()에서 초기화진행
                 */
                cell.favoriteButton.rx.tap.bind {
                    if isFavorite {
                        self?.deleteFavorite.accept(user.id) // 해제
                    } else {
                        self?.saveFavorite.accept(user) // 저장
                    }
                    
                }.disposed(by: cell.disposeBag)
            }
            
            return cell
        }.disposed(by: disposeBag)


        output.error
            // .observe(on: MainScheduler.instance) // ✅ UI 업데이트니까!
            .bind { [weak self] errorMessage in
            let alert = UIAlertController(title: "에러", message: errorMessage, preferredStyle: .alert)
            alert.addAction(.init(title: "확인", style: .default))
            self?.present(alert, animated: true)
        }.disposed(by: disposeBag)
    }
    
    
    private func setUI() {
        view.addSubview(searchTextField)
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16) // 좌우
            $0.height.equalTo(44)
        }
        
        view.addSubview(tabButtonView)
        tabButtonView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(tabButtonView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setUI()
        
        // 구독
        bindView()
        
        // 뷰모델 연결
        bindViewModel()
        
        tableView.rx.prefetchRows.bind { [weak self] indexPath in
            // 총 리스트 개수
            // 현재 인덱스
            
            guard let rows = self?.tableView.numberOfRows(inSection: 0), let itemIndex = indexPath.first?.item else { return }
            if itemIndex >= rows - 1 { // 마지막 전에 왔을 때
                self?.fetchMore.accept(())
            }
        }.disposed(by: disposeBag)
    }
}


