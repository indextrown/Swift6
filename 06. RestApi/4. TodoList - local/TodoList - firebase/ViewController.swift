//
//  ViewController.swift
//  TodoList - firebase
//
//  Created by 김동현 on 4/2/25.
//

import UIKit
import FirebaseDatabase

struct TodoEntity {
    var todo: String
    var isDone: Bool
}

class ViewController: UIViewController {
    var ref: DatabaseReference?

    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var todoInputTextField: UITextField!
    
    var todoList: [TodoEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database(url: "https://indextodolist-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        // 내가 가지고 있는 todoTable의 dataSource는 나자신이다
        self.todoTableView.dataSource = self
        self.todoTableView.delegate = self
    }
    
    @IBAction func addTodoBtnClicked(_ sender: UIButton) {
        print(#fileID, #function, #line, "- ")
        // let userInput = todoInputTextField.text ?? "" // 이것도 가능
        guard let userInput = todoInputTextField.text, !userInput.isEmpty else {
            preentAlert()
            return
        }
        
        let newTodo = TodoEntity(todo: userInput, isDone: false)
         self.todoList.append(newTodo)
//        self.ref?
//            .child("Todos")
//            .childByAutoId()
//            .setValue([
//                "todo": newTodo.todo,
//                "isDone": newTodo.isDone
//            ] as [String: Any])
        
        // 1번방식: 업데이트
        // self.todoTableView.reloadData()
        // 2번방식: 애니메이션처리 + 업데이트
         let newIndexPath = IndexPath(row: self.todoList.count - 1, section: 0)
        self.todoTableView.insertRows(at: [newIndexPath], with: .fade)
        
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
        let alert = UIAlertController(title: "수정",
                                      message: "할일을 수정해주세요", preferredStyle: .alert)
     
        alert.addTextField()
        
        let inputTF = alert.textFields?.first
        inputTF?.text = currentTodo.todo
        
        let editActon = UIAlertAction(title: NSLocalizedString("완료",
                                      comment: "Default action"),
                                      style: .default, handler: { [weak self] _ in
            guard let self = self,
                  let userInput = inputTF?.text else { return }
            self.todoList[indexPath.row].todo = userInput
            // 1번방식
            // self.todoTableView.reloadData()
            
            // 2번방식
            self.todoTableView.reloadRows(at: [indexPath], with: .fade)
        })
        
        let cancleActon = UIAlertAction(title: NSLocalizedString("닫기",
                                        comment: "Default action"),
                                        style: .cancel, handler: { _ in })
        
        alert.addAction(editActon)
        alert.addAction(cancleActon)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - 등록과정은 스토리보드로 id 진행
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  화면에 보여줄 셀을 재사용해서 가져오는 부분
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        
        let cellData: TodoEntity = todoList[indexPath.row]
        cell.todoLabel.text = cellData.todo
        cell.isDoneSwitch.isOn = cellData.isDone
        cell.selectionStyle = .none
        
        cell.indexPath = indexPath
        cell.isDoneAction = { [weak self] indexPath, isDone in
            print(#fileID, #function, #line, "- indexPath: \(indexPath), isDone: \(isDone)")
            
            // 1. 데이터 변경
            self?.todoList[indexPath.row].isDone = isDone
            
            // 2. UI 업데이트 - 안해도됨
            // tableView.reloadData()
            // tableView.reloadRows(at: [indexPath], with: .fade)
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _,_,_  in
            print(#fileID, #function, #line, "- 삭제: \(indexPath)")
            // 1. 데이터 지우기
            self.todoList.remove(at: indexPath.row)
            // 2-1. 셀 리로드 혹은 지우기
            // tableView.reloadData()
            
            // 2-2. 애니메이션방식
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let cellConfig = UISwipeActionsConfiguration(actions: [deleteAction ])
        return cellConfig
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "수정") { [weak self] _,_,_  in
            
            guard let self = self else { return }
            print(#fileID, #function, #line, "- 수정: \(indexPath)")
            let currentTodo = self.todoList[indexPath.row]
            self.preentEditTodoAlert(currentTodo: currentTodo, indexPath: indexPath)
        }
        
        let cellConfig = UISwipeActionsConfiguration(actions: [editAction ])
        cellConfig.performsFirstActionWithFullSwipe = false
        return cellConfig
    }
}
 
