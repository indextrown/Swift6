//
//  TodosVC4.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 8/4/25.
//

/*
 https://github.com/RxSwiftCommunity/RxDataSources
 https://github.com/ReactiveX/RxSwift
 */

/*
let data = Observable<[String]>.just(["first element", "second element", "third element"])

data.bind(to: tableView.rx.items(cellIdentifier: "Cell")) { index, model, cell in
  cell.textLabel?.text = model
}
.disposed(by: disposeBag)
*/


import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import RxRelay

final class TodosVC4: UIViewController {
    
    private lazy var myTableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    var todoList: [Todo] = []
    var todosDataSource: TodosDataSource3? = nil
    
    // MARK: - 구독에 대한 찌꺼기 처리
    var disposeBag =  DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        rxSetting()
        makeUI()
        constraints()
    }
    
    private func rxSetting() {
        let data = Observable<[Todo]>.just(Todo.getDumies())
        self.myTableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.reuseIdentifier)
        
        // MARK: - Bind: 구독
        // ✅ TodoCell을 타입으로 명시하여 바인딩하는 간결한 방식
        data.bind(to: myTableView.rx.items(cellIdentifier: TodoCell.reuseIdentifier,
                                           cellType: TodoCell.self)) { index, model, cell in
            cell.configure(with: model)
        }
       .disposed(by: disposeBag)
        
        // ✅ 두 번째 방식 (더 유연하지만 수동 캐스팅 필요 – RxCocoa)
        data.bind(to: myTableView.rx.items) { (tableView, rox, element) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.reuseIdentifier) as? TodoCell else { return UITableViewCell()}
            
            cell.configure(with: element)
            return cell
        }
        .disposed(by: disposeBag)
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

