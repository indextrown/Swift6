//
//  ViewController.swift
//  TodoList - firebase
//
//  Created by 김동현 on 4/2/25.
//

import UIKit
import FirebaseDatabase

struct TodoEntity {
    var refId: String
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
        ref = Database
            .database(url: "https://indextodolist-default-rtdb.asia-southeast1.firebasedatabase.app")
            .reference().child("Todos")
        
        // 내가 가지고 있는 todoTable의 dataSource는 나자신이다
        self.todoTableView.dataSource = self
        self.todoTableView.delegate = self
        
        // MARK: - 값 전체를 옵저빙중...
        // MARK: - 데이터 수신 - ref?.observe(.value)는 Todos 경로에 변화가 생길 때마다 호출되는 리스너
        /*
        ref?.observe(.value) { snapshot in
            self.todoList = []
            for child in snapshot.children {
                guard let childSnapShot = child as? DataSnapshot else { return }
                let value = childSnapShot.value as? NSDictionary
                let todo = value?["todo"] as? String ?? ""
                let isDone = value?["isDone"] as? Bool ?? false
                
                
                let fetchedTodoEntity = TodoEntity(refId: childSnapShot.key, todo: todo, isDone: isDone)
                print(#fileID, #function, #line, "- fetchedTodoEntity: \(fetchedTodoEntity)")
                self.todoList.append(fetchedTodoEntity)
            }
            self.todoTableView.reloadData()
        }
         */
        
        // MARK: - 데이터 한번만 받기
        ref?.getData(completion: { error, snapshot in
            if let error = error {
                print(#fileID, #function, #line, "- 에러: \(error)")
                return
            }
            guard let snapshot = snapshot else { return }
            self.todoList = []
            for child in snapshot.children {
                guard let childSnapShot = child as? DataSnapshot else { return }
                let value = childSnapShot.value as? NSDictionary
                let todo = value?["todo"] as? String ?? ""
                let isDone = value?["isDone"] as? Bool ?? false
                
                let fetchedTodoEntity = TodoEntity(refId: childSnapShot.key, todo: todo, isDone: isDone)
                print(#fileID, #function, #line, "- fetchedTodoEntity: \(fetchedTodoEntity)")
                self.todoList.append(fetchedTodoEntity)
            }
            self.todoTableView.reloadData()
        })

        // Listen for deleted comments in the Firebase database
        // MARK: - 삭제가 일어났을때만 받겠다
        ref?.observe(.childRemoved, with: { (snapshot) -> Void in
            guard let index: Int = self.todoList.firstIndex(where: {$0.refId == snapshot.key}) else { return }
            self.todoList.remove(at: index)
            let removingIndexPath = IndexPath(row: index, section: 0)
            self.todoTableView.deleteRows(at: [removingIndexPath], with: .fade)
        })
        
        // MARK: - 데이터 추가가 일어났을때만 받겠다
        ref?.observe(.childAdded, with: { (snapshot) -> Void in
            let value = snapshot.value as? NSDictionary
            let todo = value?["todo"] as? String ?? ""
            let isDone = value?["isDone"] as? Bool ?? false
            let addedTodoEntity = TodoEntity(refId: snapshot.key, todo: todo, isDone: isDone)
            print(#fileID, #function, #line, "- addedTodoEntity: \(addedTodoEntity)")
            
            // 1. 데이터 추가
            self.todoList.append(addedTodoEntity)
            
            // 2. UI 업데이트
            let appendingIndexPath = IndexPath(row: self.todoList.count - 1, section: 0)
            self.todoTableView.insertRows(at: [appendingIndexPath], with: .fade)
        })
        
        // MARK: - 특정 데이터가 변경되었을 때만 받겠다
        ref?.observe(.childChanged, with: { (snapshot) -> Void in
            let value = snapshot.value as? NSDictionary
            let todo = value?["todo"] as? String ?? ""
            let isDone = value?["isDone"] as? Bool ?? false
            let changedTodoEntity = TodoEntity(refId: snapshot.key, todo: todo, isDone: isDone)
            print(#fileID, #function, #line, "- changedTodoEntity: \(changedTodoEntity)")
            
            guard let index: Int = self.todoList.firstIndex(where: {$0.refId == snapshot.key}) else { return }
            
            // 1. 데이터 변경
            self.todoList[index] = changedTodoEntity
            let changingIndexPath = IndexPath(row: index, section: 0)
            
            
            // 2. UI 업데이트
            self.todoTableView.reloadRows(at: [changingIndexPath], with: .fade)
            // let appendingIndexPath = IndexPath(row: self.todoList.count - 1, section: 0)
            // self.todoTableView.insertRows(at: [appendingIndexPath], with: .fade)
        })
        
    }
    
    @IBAction func addTodoBtnClicked(_ sender: UIButton) {
        print(#fileID, #function, #line, "- ")
        // let userInput = todoInputTextField.text ?? "" // 이것도 가능
        guard let userInput = todoInputTextField.text, !userInput.isEmpty else {
            preentAlert()
            return
        }
        
        // let newTodo = TodoEntity(todo: userInput, isDone: false)
        // self.todoList.append(newTodo)
        self.ref?
        //.child("Todos")
            .childByAutoId()
            .setValue([
                "todo": userInput,
                "isDone": false
            ] as [String: Any])
        
        // 1번방식: 업데이트
        // self.todoTableView.reloadData()
        // 2번방식: 애니메이션처리 + 업데이트
        // let newIndexPath = IndexPath(row: self.todoList.count - 1, section: 0)
        //self.todoTableView.insertRows(at: [newIndexPath], with: .fade)
        //
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
            
            let editingTodo = self.todoList[indexPath.row]
            
            self.ref?
                .child(editingTodo.refId)
                .updateChildValues(["todo": userInput], withCompletionBlock: {_,_ in})
            
            // self.todoList[indexPath.row].todo = userInput
            // 1번방식
            // self.todoTableView.reloadData()
            
            // 2번방식
            // self.todoTableView.reloadRows(at: [indexPath], with: .fade)
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
            guard let self = self else { return }
            let isDoneCheckingTodo = self.todoList[indexPath.row]
            
            self.ref?
                .child(isDoneCheckingTodo.refId)
                .updateChildValues(["isDone": isDone], withCompletionBlock: { _, _ in})
            //.setValue(["todo": isDoneCheckingTodo.todo, "isDone": isDone])
            
            
            // 1. 데이터 변경
            // self?.todoList[indexPath.row].isDone = isDone
            
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
            // self.todoList.remove(at: indexPath.row)
            
            let todoToBeDeleted = self.todoList[indexPath.row]
            print("테스트: \(todoToBeDeleted)")
            
            self.ref?
                .child(todoToBeDeleted.refId)
                .removeValue()
            
            // 2-1. 셀 리로드 혹은 지우기
            // tableView.reloadData()
            
            // 2-2. 애니메이션방식
            // tableView.deleteRows(at: [indexPath], with: .fade)
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

