//
//  MainVC.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 3/24/25.
//

import UIKit
import SwiftUI
import RxSwift // 기본 형태
import RxRelay // relay라는 subject 상위 단계인 relay를 추가했다고 생각(실패를 하더라도 스트림 흐름이 끊기지 않는다)
import RxCocoa // Cocoa Touch Class: UI에 관련된 것들을 Rx와 접목시킨것

final class MainVC: UIViewController {
    var dispiseBag = DisposeBag()
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var pageInfoLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var selectedTodosInfoLabel: UILabel!
    // 할 일 추가 버튼
    @IBOutlet weak var showAddTodoAlertButton: UIButton!
    // 선택된 할일들 삭제 버튼
    @IBOutlet weak var deleteSelectedTodosBtn: UIButton!
    
    // MARK: - Lazy는 사용할떄 메모리에 올린다는 의미
    // MARK: - 바텀 인디케이터뷰
    lazy var bottomIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = UIColor.systemBlue
        indicator.startAnimating()
        indicator.frame = CGRect(x: 0, y: 0, width: myTableView.bounds.width, height: 44)
        return indicator
    }()
    
    // MARK: - 새로고침 뷰
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        // refreshControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        refreshControl.tintColor = .systemBlue.withAlphaComponent(0.5)
        refreshControl.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - 검색결과를 찾미 못했을때 뷰
    lazy var searchDataNotFoundView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: myTableView.bounds.width, height: 300))
        let label = UILabel()
        label.text = "⚠️ 검색결과를 찾을 수 없습니다"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }()
    
    // MARK: - 더 이상 가져올 데이터가 없을때 뷰
    lazy var bottomNoMoreDataView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: myTableView.bounds.width, height: 60))
        
        let label = UILabel()
        label.text = "⚠️ 더 이상 가져올 데이터가 없습니다."
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }()
    
    // 외부에서 ViewController가 생성될 때 넣어주면 된다
    var todosVM_main: TodosVMClosure = TodosVMClosure() // 일단은 생성될때 바로 넣어주도록 처리
    
    var todosVM: TodosVMRx = TodosVMRx() // 일단은 생성될때 바로 넣어주도록 처리
    
    var todos: [Todo] = []
    
    var searchTermInputWorkItem: DispatchWorkItem? = nil
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        self.view.backgroundColor = .systemYellow
        
        // MARK: - 버튼 액션 설정
        self.showAddTodoAlertButton.addTarget(self, action: #selector(showAddTodoAlert), for: .touchUpInside)
        
        self.deleteSelectedTodosBtn.addTarget(self, action: #selector(onDeleteSelectedTodosBtnClicked), for: .touchUpInside)
        
        // MARK: - 테이블뷰 설정
        // 테이블뷰에 셀 등록            // 자기자신에 대한 nib파일 바로 가져올 수 있음
        self.myTableView.register(TodoCell.uinib, forCellReuseIdentifier: TodoCell.reuseIdentifier)
        // self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.myTableView.refreshControl = refreshControl
        self.myTableView.tableFooterView = bottomIndicator
        
        // MARK: - 서치바 설정
        self.searchBar.searchTextField.rx.text.orEmpty
            .debug("✅ searchTextField")
            .bind(onNext: ( self.todosVM.searchTerm.accept(_:)))
            .disposed(by: dispiseBag)
        
        // MARK: - 뷰모델 설정
        // MARK: - 1-2. Tableiew datasource대신 RxDatasource로 교체
        self.todosVM
            .todos // BehaviorRelay<[Todo]> = Observable의 일종
            .bind(to: self.myTableView.rx.items(cellIdentifier: TodoCell.reuseIdentifier, cellType: TodoCell.self)) { [weak self] index, cellData, cell in
                guard let self = self else { return }
                cell.updateUI(cellData, self.todosVM.selectedTodoIds)
                cell.onDeleteActionEvent = self.onDeleteItemAction
                cell.onEditActionEvent = self.onEditItemAction
                cell.onSelectedActionEvent = self.onSelectionItemAction(_:_:)
            }
            .disposed(by: dispiseBag)
        
        self.todosVM
            .currentPageInfo
            .bind(to: self.pageInfoLabel.rx.text)
            .disposed(by: dispiseBag)
        
        // MARK: - api 새로고침
        self.todosVM.notifyLoadingStateChanged = { [weak self] isLoading in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isLoading {
                    self.myTableView.tableFooterView = self.bottomIndicator
                } else {
                    self.myTableView.tableFooterView = nil
                }
            }
        }
        
        // MARK: - 당겨서 새로고침 완료
        self.todosVM.notifyRefreshEnded = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
                self.refreshControl.endRefreshing()
            }
        }
        
        // MARK: - 검색결과 없음 여부
        self.todosVM.notifySearchDataNotFound = { [weak self] notFound in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.myTableView.backgroundView = notFound ? self.searchDataNotFoundView : nil
            }
        }
        
        // MARK: - 다음페이지 존재 여부
        self.todosVM
            .notifyHasNextPage
            .map { !$0 ? self.bottomNoMoreDataView : nil }
            .bind(to: self.myTableView.rx.tableFooterView) // Binder<UIView?> 타입이라 메인스레드 보장됨
            .disposed(by: dispiseBag)
        
        // MARK: - 할 일 추가완료
        self.todosVM.notifyTodoAdded = { [weak self] in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.myTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
        // MARK: - 에러 발생시
        self.todosVM.notifyErrorOccured = { [weak self] errorMsg in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.showAlert(errorMSG: errorMsg)
            }
        }
        
        // MARK: - 할일 선택시
        self.todosVM.notifySelectedTodoIdsChanged = { [weak self] selectedTodoIds in
            guard let self = self else { return }

            DispatchQueue.main.async {
                let idsInfoString = selectedTodoIds.map { "\($0)" }.joined(separator: ", ")
                self.selectedTodosInfoLabel.text = "선택된 할일들: [" + idsInfoString + "]"
                                                                  
            }
        }
    }
}

extension MainVC: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !self.todosVM.isLoading else { return } // 중복 방지
        
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset

        if distanceFromBottom - 300 < height {
            // print("You reached end of the table")
            // todosVM.page += 1
            // print(todosVM.page)
            print("바닥이다")
            self.todosVM.fetchMore() 
        }
    }
}

// 1. 개수
// 2. 어떤 셀에 보여줄지 cellForRowAt
/*
extension MainVC: UITableViewDataSource {
    // 각 셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // MARK: - 둘다 가능
        return todos.count
        // return todosVM.todos.count
    }
    
    // MARK: - cellForRowAt는 메인스레드에서 호출된다
    // 각각에 대한 셀 가져오기
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.reuseIdentifier, for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        
        let cellData = self.todos[indexPath.row]
        
        
        
        // 데이터 셀에 넣어주기
        cell.updateUI(cellData, self.todosVM.selectedTodoIds)
        
        
        
        
        /*
        cell.onDeleteActionEvent = { selectedId in
            self.showDeleteTodoAlert(id: selectedId)
        }
         */
        
        // MARK: - 클로저를 함수로도 바꾸어보자
        /*
        cell.onDeleteActionEvent = {
            self.showDeleteTodoAlert(id: $0)
        }
         */
        
        cell.onDeleteActionEvent = onDeleteItemAction
        cell.onEditActionEvent = onEditItemAction
        cell.onSelectedActionEvent = onSelectionItemAction(_:_:)
        
        
        return cell
    }
}
 */

extension MainVC {
    // MARK: - uikit을 대신하는 SwiftUI View
    private struct VCRepresentale: UIViewControllerRepresentable {
        
        let mainVC: MainVC
        
        // swiftUI에서는 2가지 존재 1) 데이터 상태가 변경되면 즉 state, binding 값이 변경되면 update를 해줘야 한다
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        
        // 뷰컨트롤러를 반환하면 그걸 감싼 UIViewControllerRepresentable 라는 swiftUI View가 나오게 된다
        func makeUIViewController(context: Context) -> some UIViewController {
            return mainVC
        }
    }
    
    func getRepresentable() -> some View {
        VCRepresentale(mainVC: self)
    }
}

extension MainVC {
    // MARK: - 새로고침
    @objc fileprivate func handleRefresh(_ sender: UIRefreshControl) {
        /*
        DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
            sender.endRefreshing()
        }
         */
        // MARK: - 뷰모델한테 시키기
        self.todosVM.fetchRefresh()
    }
    
    
    // MARK: - 셀의 삭제 버튼 클릭시
    @objc fileprivate func onDeleteItemAction(_ id: Int) {
        print("아이디: \(id)")
        self.showDeleteTodoAlert(id: id)
    }

    /// 셀의 수정 버튼 클릭시
    /// - Parameters:
    ///   - id: 아이디
    ///   - title: 변경된 타이틀
    @objc fileprivate func onEditItemAction(_ id: Int, _ title: String) {
        self.showEditdoAlert(id, title)
    }
    
    
    /// 셀의 아이템 선택 이벤트
    /// - Parameters:
    ///   - id: 아이디
    ///   - isOn: 선택여부
    @objc fileprivate func onSelectionItemAction(_ id: Int, _ isOn: Bool) {
        self.todosVM.handleTodoSelection(id, isOn: isOn)
    }
    
    
    
}


// MARK: - 액션들
extension MainVC {
    /*
    // MARK: - 검색어가 입력되었다
    @objc fileprivate func searchTermChanged(_ sender: UITextField) {
        // print(#fileID, #function, #line, "- sender: \(sender.text)")
        
        // MARK: - 검색어가 입력되면 기본 작업 취소
        searchTermInputWorkItem?.cancel()
        
        let dispatchWorkItem = DispatchWorkItem {
            // MARK: - 백그라운드
            // 스레드 변경 - userInteractive: 사용자 입력 관련, async는 비동기,
            DispatchQueue.global(qos: .userInteractive).async {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let userInput = sender.text ?? ""
                    print(#fileID, #function, #line, "- API 호출\(userInput)")
                    // #warning("Todo: - 검색 API 호출하기")
                    self.todosVM.todos.accept([])
                    //self.todosVM.todos.accept([])
                    
                    // MARK: - 뷰모델 검색어 갱신
                    self.todosVM.searchTerm = userInput
                }
            }
        }
        
        
        // MARK: - 기존 작업을 나중에 취소하기 위해 메모리 주서 일치 시켜줌
        self.searchTermInputWorkItem = dispatchWorkItem
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.7, execute: dispatchWorkItem)
    }
     */
    @objc fileprivate func onDeleteSelectedTodosBtnClicked(_ sender: UIButton) {
        self.todosVM.deleteSelectedTodos()
    }
}

// MARK: - 얼럿
extension MainVC {
    /// 헐일 추가 얼럿 띄우기
    @objc fileprivate func showAddTodoAlert() {
        // 1. Create the alert controller
        let alert = UIAlertController(title: "추가", message: "할 할일을 입력해주세요", preferredStyle: .alert)
        
        // 2. Add the text field. You can configure it however you need.
        alert.addTextField { (textfield) in
            textfield.placeholder = "예시) 코딩하기"
        }
        
        // 3. Grab the value from the next field, and print in when the user clicks Ok,
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: { [weak alert] (_) in
            if let userInput = alert?.textFields?[0].text {
                print("userInput: \(userInput)")
                self.todosVM.addATodo(userInput)
            }
        })
        
        let closeAction = UIAlertAction(title: "닫기", style: .destructive)
        alert.addAction(confirmAction)
        alert.addAction(closeAction)
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    /// 에러 얼럿 띄우기
    /// - Parameter errorMSG: 서버 에러 메시지
    @objc fileprivate func showAlert(errorMSG: String) {
        let alert = UIAlertController(title: "안내", message: errorMSG, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "닫기", style: .destructive)
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /// 할일 삭제 얼럿 띄우기
    /// - Parameter id: 삭제할 게시글 아이디
    @objc fileprivate func showDeleteTodoAlert(id: Int) {
        let alert = UIAlertController(title: "할일 삭제", message: "\(id) 할일을 삭제하시겠습니까?", preferredStyle: .alert)
        let subminAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.todosVM.deleteATodo(id)
        }
        let closeAction = UIAlertAction(title: "닫기", style: .destructive)
        alert.addAction(subminAction)
        alert.addAction(closeAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// 할일 수정 얼럿 띄우기
    /// - Parameters:
    ///   - id: 아이디
    ///   - existingTitle: 기존 타이틀
    @objc fileprivate func showEditdoAlert(_ id: Int, _ existingTitle: String) {
        // 1. Create the alert controller
        let alert = UIAlertController(title: "수정", message: "id: \(id)", preferredStyle: .alert)
        
        // 2. Add the text field. You can configure it however you need.
        alert.addTextField { (textfield) in
            textfield.placeholder = "예시) 코딩하기"
        }
        
        // 3. Grab the value from the next field, and print in when the user clicks Ok,
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: { [weak alert] (_) in
            if let userInput = alert?.textFields?[0].text {
                print("userInput: \(userInput)")
                self.todosVM.editATodo(id, userInput)
            }
        })
        
        let closeAction = UIAlertAction(title: "닫기", style: .destructive)
        alert.addAction(confirmAction)
        alert.addAction(closeAction)
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
}
