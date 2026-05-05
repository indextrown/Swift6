//
//  TodosDataSource2.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 8/3/25.
//

import UIKit

// MARK: - 구현 목적: VC에 부담을 주지말자
final class TodosDataSource2: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var todoList: [Todo] = []
    var tableView: UITableView? = nil
    
    // MARK: - 로직을 밖으로 뺄 수 있다 즉 VC에서 클로저로 사용 가능하다.
    // configureCell 클로저: 셀 구성 로직을 VC에서 정의할 수 있게 위임함
    // 매개변수 tableView, indexPath는 외부에서 받아오고
    // cellData(todo)는 내부 todoList에서 가져와 주입
    var configureCell: ((UITableView, IndexPath, Todo) -> UITableViewCell)?
    
    init(todoList: [Todo], tableView: UITableView) {
        self.todoList = todoList
        self.tableView = tableView
    }
    
    // MARK: - Register
    func register<T: UITableViewCell>(cellType: T.Type) {
        tableView?.register(cellType, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func setData(newValue: [Todo]) {
        self.todoList = newValue
        self.tableView?.reloadData()
    }
    
    // MARK: - UITableView Datasource Methods
    /// 하나의 섹션에 몇개의 rows가 있냐
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    // 각 셀에 대한 내용을 구성하여 반환 -> 셀의 종류를 정하기 - 테이블뷰 셀을 만들어서 반환해라
    /// - indexPath: 셀의 위치를 나타내는 인덱스 경로
    /// - returns: 구성된 UITableViewCell 객체e
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = todoList[indexPath.row]
        return configureCell?(tableView, indexPath, cellData) ?? UITableViewCell()
    }
}
