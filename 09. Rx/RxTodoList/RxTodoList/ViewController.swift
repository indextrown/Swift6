//
//  ViewController.swift
//  RxTodoList
//
//  Created by 김동현 on 4/12/25.
//

/*
 Input → ViewModel → Output → View
 bindUI() - 값을 준비하는 역할,
 bindViewModel() - 값을 ViewModel에 실제 연결하는 역할
 
 사용자 버튼 탭
      ↓
 withLatestFrom(텍스트 필드 값)
      ↓
 addTodoRelay.accept("할일")
      ↓
 transform(input: addTodoRelay.asObservable())
      ↓
 ViewModel 내부 로직 처리
 
 1. 뷰가 로드됨
 2. bindUI()가 사용자 액션을 중간 Relay에 바인딩
 3. bindViewModel()이 Relay를 ViewModel Input으로 넘김
 4. 버튼 탭 → 텍스트 → Relay로 전달됨
 5. ViewModel이 값 받아서 가공
 6. Output으로 가공된 리스트를 다시 View에 전달
 7. TableView가 reloadData()됨

 
 bindUI()
 - ViewModel Input 전달
 
 bindViewModel()
 - Output → View 연결
 - Input 스트림을 ViewModel과 연결해두고,
 - Output 스트림을 View가 구독하도록 한 번만 세팅하는 함수
 - 이벤트가 올 때마다 그 선을 타고 계속 전달
 */
import UIKit
import RxSwift // disposeBag
import RxCocoa // tap

final class ViewController: UIViewController {
    
    // IBOutlet
    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var todoInputTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    // Properties
    private let disposeBag = DisposeBag()
    private let viewModel = TodoViewModel()
    
    // data
    private var todoList: [TodoEntity] = []
    private let addTodoRelay = PublishRelay<String>() // Input 전달용
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        setDelegate()
        bindUI()
        bindViewModel()
    }

    private func makeUI() {
        view.backgroundColor = .black
    }
    
    private func setDelegate() {
        todoTableView.dataSource = self
        todoTableView.delegate = self
    }
    
    // 사용자의 입력을 중간 Relay로 전달 (이 Relay는 viewModel의 Input으로 사용됨)
    private func bindUI() {
        // 버튼 탭 -> 텍스트 -> Relay
        addButton.rx.tap
            .withLatestFrom(todoInputTextField.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .bind(to: addTodoRelay)
            .disposed(by: disposeBag)
        
        // 입력창 초기화
        addButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.todoInputTextField.text = ""
            })
            .disposed(by: disposeBag)
    }
    
    // viewModel의 Output을 구독해서, 새로운 값이 오면 화면 갱신
    // ViewModel과의 연결 → Input 전달 + Output 구독
    // 이벤트 연결선"을 한 번 설치
    private func bindViewModel() {
        // viewModel에서 받을 input 만들기
        let input = TodoViewModel.Input.init(
            // 버튼탭 -> 문자열(할일) Observable
            addTodoTapped: addTodoRelay.asObservable())
        
        // ViewModel에게 input 전달
        let output = viewModel.transform(input: input)
        
        output.todoList
            .bind(onNext: { [weak self] todos in
                guard let self = self else { return }
                self.todoList = todos
                // print("🟢 받은 todos: \(todos)")

                self.todoTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    

}

// MARK: - 등록과정은 스토리보드로 id 진행
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList.count
    }
    
    func tableView(_ tableView: UITableView,
                       cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }

        let item = todoList[indexPath.row]
        cell.todoLabel.text = item.todo
        cell.isDoneSwitch.isOn = item.isDone
        cell.selectionStyle = .none
        cell.indexPath = indexPath

        // ✅ 완료 여부 토글
        cell.isDoneAction = { [weak self] indexPath, isDone in
            self?.viewModel.updateIsDone(for: indexPath.row, isDone: isDone)
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    // ✅ 삭제 스와이프
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, _ in
            self?.viewModel.deleteTodo(at: indexPath.row)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    // ✅ 수정 스와이프
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "수정") { [weak self] _, _, _ in
            self?.presentEditAlert(at: indexPath)
        }

        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    private func presentEditAlert(at indexPath: IndexPath) {
            let current = todoList[indexPath.row]
            let alert = UIAlertController(title: "수정", message: "할 일을 수정하세요", preferredStyle: .alert)
            alert.addTextField { $0.text = current.todo }

            let confirm = UIAlertAction(title: "완료", style: .default) { [weak self] _ in
                guard let newText = alert.textFields?.first?.text, !newText.isEmpty else { return }
                self?.viewModel.editTodo(at: indexPath.row, newText: newText)
            }

            alert.addAction(confirm)
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))

            self.present(alert, animated: true)
        }

}

