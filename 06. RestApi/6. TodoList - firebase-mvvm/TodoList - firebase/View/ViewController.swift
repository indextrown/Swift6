//
//  ViewController.swift
//  TodoList - firebase
//
//  Created by 김동현 on 4/2/25.
//

import UIKit
import FirebaseDatabase



class ViewController: UIViewController {
    var ref: DatabaseReference?
    
    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var todoInputTextField: UITextField!
    private let viewModel = TodoViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 내가 가지고 있는 todoTable의 dataSource는 나자신이다
        self.todoTableView.dataSource = self
        self.todoTableView.delegate = self
        
        bindViewModel()
        // viewModel.fetchTodos()
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.todoTableView.reloadData()
        }
        
        viewModel.onInsert = { [weak self] indexPath in
            self?.todoTableView.insertRows(at: [indexPath], with: .fade)
        }
        
        viewModel.onDelete = { [weak self] indexPath in
            self?.todoTableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        viewModel.onChange = { [weak self] indexPath in
            self?.todoTableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func addTodoBtnClicked(_ sender: UIButton) {
        print(#fileID, #function, #line, "- ")
        // let userInput = todoInputTextField.text ?? "" // 이것도 가능
        guard let userInput = todoInputTextField.text, !userInput.isEmpty else {
            preentAlert()
            return
        }
        viewModel.addTodo(userInput)
        todoInputTextField.text = ""
    }
    
    fileprivate func preentAlert() {
        let alert = UIAlertController(title: "안내",
                                      message: "할일이 비어있습니다.", preferredStyle: .alert)
        
        let acton = UIAlertAction(title: NSLocalizedString("확인", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")})
        alert.addAction(acton)
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func preentEditTodoAlert(currentTodo: TodoEntity, indexPath: IndexPath) {
        let currentTodo = viewModel.todoList[indexPath.row]
                let alert = UIAlertController(title: "수정", message: "할일을 수정해주세요", preferredStyle: .alert)
                alert.addTextField { $0.text = currentTodo.todo }
                alert.addAction(UIAlertAction(title: "완료", style: .default) { [weak self] _ in
                    if let newText = alert.textFields?.first?.text {
                        self?.viewModel.updateTodo(indexPath: indexPath, newText: newText)
                    }
                })
                alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
                present(alert, animated: true)
    }
}

// MARK: - 등록과정은 스토리보드로 id 진행
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        let todo = viewModel.todoList[indexPath.row]
        cell.todoLabel.text = todo.todo
        cell.isDoneSwitch.isOn = todo.isDone
        cell.indexPath = indexPath
        cell.isDoneAction = { [weak self] indexPath, isDone in
            self?.viewModel.toggleIsDone(indexPath: indexPath, isDone: isDone)
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, _ in
            self?.viewModel.deleteTodo(indexPath: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "수정") { [weak self] _, _, _ in
            guard let self = self else { return }
            let currentTodo = self.viewModel.todoList[indexPath.row]
            self.preentEditTodoAlert(currentTodo: currentTodo, indexPath: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [edit])
    }
}
