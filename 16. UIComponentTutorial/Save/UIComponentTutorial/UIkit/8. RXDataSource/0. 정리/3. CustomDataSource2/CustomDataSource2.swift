//
//  CustomDataSource2.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/22/25.
//
/*
 커스텀 데이터소스 정리
 - 로직을 데이터소스에 맡길 수 있다(데이터가 몇개인지, 어떤 셀을 보여줄지)
 - 특히 커스텀데이터소스에서 셀 로직 처리 가능해진다
    - 하지만 셀에 대한 로직을 바깥쪽에서 정하고 싶을 때 문제가 발생할 수 있다
    - 이를 해결하기 위해 클로저로 매개변수 로직을 받아서 자유롭게 만들자 - configureCell
    - rxDatasource도 셀에 대한 로직을 정하는 부분이 클로저로 되어 있다
 */


/*
import UIKit

// MARK: - 셀 개수, 어떤 셀을 보여줄지 관리를 커스텀 데이터소스에 맡기는 방식
final class CustomDataSource2: NSObject, UITableViewDataSource {
    
    var todoList: [Todo] = []
    var tableView: UITableView? = nil
    var configureCell: ((CustomDataSource2, UITableView, Int, Todo, RxCell) -> Void)? = nil
    
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

        let cell = tableView.dequeueReusableCell(withIdentifier: RxCell.reuseIdentifier, for: indexPath) as! RxCell
        
        configureCell?(self, tableView, indexPath.row, cellData, cell)
        
        return cell
    }
}

// MARK: - ViewController
final class CustomDataSourceVC2: UIViewController {
    
    private var todoList: [Todo] = [
        Todo(id: 0, title: "RxSwift 공부하기", isDone: false),
        Todo(id: 1, title: "UI 구성하기", isDone: false),
        Todo(id: 2, title: "코드 리뷰", isDone: false)
    ]
    private var customDataSource2: CustomDataSource2? = nil
    
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
        
        self.customDataSource2 = CustomDataSource2(todoList: self.todoList,
                                                   tableView: self.myTableView)
        
        myTableView.dataSource = self.customDataSource2
        self.customDataSource2?.register(cellType: RxCell.self)
        
        // 셀에 대한 로직 정의
        self.customDataSource2?.configureCell = { dataSource, tableView, index, cellData, cell in
            // cell.idLabel.text = "아이디: \(cellData.id)"
            // cell.isDoneSwitch.isOn = cellData.isDone
            
            cell.configure(with: cellData)
            cell.isDoneChange = { [weak self] id, isDone in
                guard let self = self else { return }
                if let foundIndex = todoList.firstIndex(where: { $0.id == id }) {
                    self.customDataSource2?.todoList[foundIndex].isDone = isDone
                    
                    DispatchQueue.main.async {
                        tableView.reloadRows(at: [IndexPath(row: foundIndex, section: 0)], with: .fade)
                    }
                }
            }

        }
    }
}
*/
