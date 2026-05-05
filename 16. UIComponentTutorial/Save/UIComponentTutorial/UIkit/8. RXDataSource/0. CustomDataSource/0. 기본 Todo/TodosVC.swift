//
//  TodosVC.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 8/3/25.
//

import UIKit

/*
final class TodosVC: UIViewController {
    
    private lazy var myTableView: UITableView = {
        let tv = UITableView()
        // MARK: - 이 부분도 TodosDataSource에 위임
        // tv.register(TodoCell.self, forCellReuseIdentifier: TodoCell.reuseIdentifier)
        return tv
    }()
    
    var todoList: [Todo] = []
    var todosDataSource: TodosDataSource? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.todoList = Todo.getDumies()
        self.todosDataSource = TodosDataSource(todoList: self.todoList, tableView: myTableView)
        self.todosDataSource?.register(cellType: TodoCell.self)
        myTableView.dataSource = todosDataSource
    
    }
}

*/


final class TodosVC: UIViewController {
    
    private lazy var myTableView: UITableView = {
        let tv = UITableView()
        // MARK: - 이 부분도 TodosDataSource에 위임
        // tv.register(TodoCell.self, forCellReuseIdentifier: TodoCell.reuseIdentifier)
        return tv
    }()
    
    var todoList: [Todo] = []
    var todosDataSource: TodosDataSource? = nil
    
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
        let dataSource = TodosDataSource(todoList: todoList, tableView: myTableView)
        
        // 2️⃣ register 호출 (이 시점에 tableView는 이미 존재함)
        dataSource.register(cellType: TodoCell.self)
        
        // 3️⃣ 연결
        self.todosDataSource = dataSource
        myTableView.dataSource = dataSource
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


