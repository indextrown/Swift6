// ViewController.swift

import UIKit
import Combine

class ViewController: UIViewController {
    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var todoInputTextField: UITextField!

    private let viewModel = TodoViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        todoTableView.dataSource = self
        todoTableView.delegate = self
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.reloadTrigger
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.todoTableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.insertSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexPath in
                self?.todoTableView.insertRows(at: [indexPath], with: .automatic)
            }
            .store(in: &cancellables)

        viewModel.deleteSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexPath in
                self?.todoTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            .store(in: &cancellables)

        viewModel.updateSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexPath in
                self?.todoTableView.reloadRows(at: [indexPath], with: .automatic)
            }
            .store(in: &cancellables)
    }

    @IBAction func addTodoBtnClicked(_ sender: UIButton) {
        guard let text = todoInputTextField.text, !text.isEmpty else {
            presentAlert()
            return
        }
        viewModel.addTodo(text)
        todoInputTextField.text = ""
    }

    private func presentAlert() {
        let alert = UIAlertController(title: "안내", message: "할일이 비어있습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

    private func presentEditAlert(indexPath: IndexPath) {
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
            self?.presentEditAlert(indexPath: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [edit])
    }
}
