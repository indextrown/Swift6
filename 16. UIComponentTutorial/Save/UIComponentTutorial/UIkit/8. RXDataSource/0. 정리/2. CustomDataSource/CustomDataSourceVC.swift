//
//  CustomDataSourceVC.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/16/25.
//

import UIKit

//// MARK: - Protocol
//protocol ReuseIdentifiable {
//    /// 프로토콜에서 로직을 정의할 수 없어서 가져올 수 있도록 설정
//    static var reuseIdentifier: String { get }
//}
//extension ReuseIdentifiable {
//    /// 로직에 대한 정의는 Extension에서 간능
//    static var reuseIdentifier: String {
//        return String(describing: Self.self)
//    }
//}

//extension UITableViewCell: ReuseIdentifiable {}






/*
// MARK: - 셀 개수, 어떤 셀을 보여줄지 관리를 커스텀 데이터소스에 맡기는 방식
final class CustomDataSource: NSObject, UITableViewDataSource {
    
    var todoList: [Todo] = []
    var tableView: UITableView? = nil
    var configureCell: ((UITableView, IndexPath, Todo) -> UITableViewCell)? = nil
    
    init(todoList: [Todo], tableView: UITableView) {
        self.todoList = todoList
        self.tableView = tableView
    }
    
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
    /// - returns: 구성된 UITableViewCell 객체
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
        // 로직 -> 매개변수로 만들자 = 클로저
         let cellData = todoList[indexPath.row]
         return configureCell?(tableView, indexPath, cellData) ?? UITableViewCell() 
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: RxCell.reuseIdentifier, for: indexPath) as? RxCell else {
//            return UITableViewCell()
//        }
//        
//        let cellData: Todo = todoList[indexPath.row]
//        cell.configure(with: cellData)
//        
//        return cell
    }
}

// MARK: - ViewController
final class CustomDataSourceVC: UIViewController {
    
    private var todoList: [Todo] = [
        Todo(id: 0, title: "RxSwift 공부하기", isDone: false),
        Todo(id: 1, title: "UI 구성하기", isDone: false),
        Todo(id: 2, title: "코드 리뷰", isDone: false)
    ]
    private var customDataSource: CustomDataSource? = nil
    
    private let myTableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        constraints()
        setCustomDataSource()
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
    
    private func setCustomDataSource() {
        // 1️⃣ dataSource 생성
        let dataSource = CustomDataSource(todoList: todoList,
                                          tableView: myTableView)
        
        // 2️⃣ register 호출 (이 시점에 tableView는 이미 존재함)
        dataSource.register(cellType: RxCell.self)
        
        // 3️⃣ 연결 - 셀이 몇개인지, 어떤 셀을 보여줄지 관리를 커스텀 데이터소스에 맡기자는 의미
        /// extension으로 데이터소스를 채택해도 되지만 vc에서 소스코드가 많아지니까.. 단순히 정리한다고 생각하자
        self.customDataSource = dataSource
        myTableView.dataSource = customDataSource
        
        self.customDataSource?.configureCell = { myTableView, indexPath, cell in
            
            guard let cell = myTableView.dequeueReusableCell(withIdentifier: RxCell.reuseIdentifier, for: indexPath) as? RxCell else {
                return UITableViewCell()
            }
    
            let cellData: Todo = self.todoList[indexPath.row]
            cell.configure(with: cellData)
            
            // MARK: -
            /// isDoneChange -해당 셀의 외부(ViewController)로 변경된 상태를 알려주는 역할을 합니다.
            /// ViewController(또는 CustomDataSource)**에서 모델(todoList)을 업데이트하고 UI도 갱신 가능ㅇ
            cell.isDoneChange = { [weak self] id, isDone in
                guard let self = self else { return }
                if let foundIndex = todoList.firstIndex(where: { $0.id == id }) {
                    self.customDataSource?.todoList[foundIndex].isDone = isDone
                    
                    DispatchQueue.main.async {
                        myTableView.reloadRows(at: [IndexPath(row: foundIndex, section: 0)], with: .fade)
                    }
                }
            }
            
    
            return cell
        }
        
        // MARK: - 3초뒤에 셀 다 사라짐
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.customDataSource?.setData(newValue: [])
        }
    }

}
*/
