//
//  TodosVC2.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 8/3/25.
//

import UIKit

final class TodosVC2: UIViewController {
    
    private lazy var myTableView: UITableView = {
        let tv = UITableView()
        // MARK: - 이 부분도 TodosDataSource에 위임
        // tv.register(TodoCell.self, forCellReuseIdentifier: TodoCell.reuseIdentifier)
        return tv
    }()
    
    var todoList: [Todo] = []
    var todosDataSource: TodosDataSource2? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.makeUI()
        self.constraints()
        
        self.todoList = Todo.getDumies()
        self.setCustomDataSource()
    }
    
    private func setCustomDataSource() {
        // 1️⃣ dataSource 생성
        todosDataSource = TodosDataSource2(todoList: todoList, tableView: myTableView)
        
        // MARK: - 여기에 클로저 추가
        self.todosDataSource?.configureCell = { mytableView, indexPath, cellData in
            
            guard let cell: TodoCell = self.myTableView.dequeueReusableCell(withIdentifier: TodoCell.reuseIdentifier, for: indexPath) as? TodoCell else { return UITableViewCell() }
            
            cell.configure(with: cellData)
            cell.isDoneChange = { [weak self] id, isDone in
                guard let self = self else { return }
                if let foundIndex = self.todoList.firstIndex( where: {$0.id == id} ) {
                    self.todosDataSource?.todoList[foundIndex].isDone = isDone
                    DispatchQueue.main.async {
                        self.myTableView.reloadRows(at: [IndexPath(row: foundIndex, section: 0)], with: .fade)
                    }
                }
            }
            
            return cell
        }
        
        // 2️⃣ register 호출 (이 시점에 tableView는 이미 존재함)
        todosDataSource?.register(cellType: TodoCell.self)
        
        // 3️⃣ 연결
        myTableView.dataSource = todosDataSource
    }
    
    private func makeUI() {
        [myTableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            myTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}



/*
guard let cell: TodoCell = tableView.dequeueReusableCell(withIdentifier: TodoCell.reuseIdentifier, for: indexPath) as? TodoCell else {
    return UITableViewCell()
}

cell.configure(with: cellData)
return cell
 */
