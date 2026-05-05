//
//  RxDataSourceVC.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/15/25.
//

import UIKit


/*
// MARK: - ViewController
final class RxDataSourceVC: UIViewController {
    
    private var todos: [Todo] = [
        Todo(id: 0, title: "RxSwift 공부하기", isDone: false),
        Todo(id: 1, title: "UI 구성하기", isDone: false),
        Todo(id: 2, title: "코드 리뷰", isDone: false)
    ]
    
    private lazy var myTableView: UITableView = {
        let tv = UITableView()
        tv.register(RxCell.self, forCellReuseIdentifier: "RxCell")
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        constraints()
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
    
    private func bindTableView() {
        
    }
}

// MARK: - UITableViewDelegate
extension RxDataSourceVC: UITableViewDelegate {}

// MARK: - UITableViewDataSource
extension RxDataSourceVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: RxCell.reuseIdentifier, for: indexPath) as? RxCell else {
            return UITableViewCell()
        }

        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        
        // MARK: - 셀 내부에서 발생한 변경 이벤트를 ViewController로 위임(delegate처럼) 하는 구조
        // MARK: - isDoneChange 클로저는 셀이 직접 모델을 수정하지 않고, ViewController가 모델을 안전하게 업데이트할 수 있게 이벤트만 전달하는 구조이기 때문에 좋은 설계
        cell.isDoneChange = { [weak self] id, isDone in
            guard let self = self else { return }
            if let foundIndex = todos.firstIndex(where: { $0.id == id }) {
                self.todos[foundIndex].isDone = isDone
                
                DispatchQueue.main.async {
                    tableView.reloadRows(at: [IndexPath(row: foundIndex, section: 0)], with: .fade)
                }
            }
        }
        
        return cell
    }
}



#Preview {
    RxDataSourceVC()
}
*/
