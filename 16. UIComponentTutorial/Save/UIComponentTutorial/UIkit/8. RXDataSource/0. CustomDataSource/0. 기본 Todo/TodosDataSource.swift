//
//  TodosDataSource.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 8/3/25.
//

import UIKit

// MARK: - 구현 목적: VC에 부담을 주지말자
final class TodosDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var todoList: [Todo] = []
    var tableView: UITableView? = nil
    
    init(todoList: [Todo], tableView: UITableView) {
        self.todoList = todoList
        self.tableView = tableView
    }
    
    // MARK: - Register
    func register<T: UITableViewCell>(cellType: T.Type) {
        tableView?.register(cellType, forCellReuseIdentifier: T.reuseIdentifier)
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
        
        
        // MARK: - 로직 -> 함수로 만들어서 매개변수로 활용해보자
        guard let cell: TodoCell = tableView.dequeueReusableCell(withIdentifier: TodoCell.reuseIdentifier, for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        
        let cellData = todoList[indexPath.row]
        cell.configure(with: cellData)
        return cell
    }
}
