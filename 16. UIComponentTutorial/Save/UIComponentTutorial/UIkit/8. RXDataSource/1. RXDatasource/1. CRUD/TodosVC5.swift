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

final class TodosVC5: UIViewController, UIScrollViewDelegate {
    
    private lazy var addButton = UIBarButtonItem(title: "추가",
                                                 style: .plain,
                                                 target: nil,
                                                 action: nil)
    
    private lazy var myTableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    var todoList: [Todo] = []
    var todosDataSource: TodosDataSource3? = nil
    
    // MARK: - 구독에 대한 찌꺼기 처리
    var disposeBag =  DisposeBag()
    
    // MARK: - 데이터 유지를 위한 바구니
    var todosRelay: BehaviorRelay<[Todo]> = BehaviorRelay(value: Todo.getDumies(10))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        rxSetting()
        makeUI()
        constraints()
    }
    
    private func rxSetting() {
        self.myTableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.reuseIdentifier)
        
        // MARK: - Bind: 구독
        
        // ✅ 두 번째 방식 (더 유연하지만 수동 캐스팅 필요 – RxCocoa)
        todosRelay
            .bind(to: myTableView.rx.items) { (tableView: UITableView, index: Int, element: Todo) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.reuseIdentifier) as? TodoCell else { return UITableViewCell()}
            
                // 현재 상태로 셀 구성
                cell.configure(with: element)
                
                // 토글 상태 변경시 해당 Todo의 isDone 변경[주석풀면 스크롤해도 토글 살아있ㅇ]
                /*
                cell.isDoneChange = { [weak self] id, newValue in

                    guard var current = self?.todosRelay.value else { return }
                    if let updateIndex = current.firstIndex(where: { $0.id == id }) {
                        current[updateIndex].isDone = newValue
                        self?.todosRelay.accept(current)
                    }
                }
                 */
                
                cell.updateActionObservable
                    .debug("updateActionObservable")
                    .bind(onNext: { [weak self] id, newValue in
                        guard var current = self?.todosRelay.value else { return }
                        if let updateIndex = current.firstIndex(where: { $0.id == id }) {
                            current[updateIndex].isDone = newValue
                            self?.todosRelay.accept(current)
                        }
                    }).disposed(by: cell.disposeBag)
                
                /*
                // 삭제 버튼 클릭시 액션
                cell.deleteAction = { [weak self] id in
                    let currentTodos = self?.todosRelay.value
                    let filteredTodos = currentTodos?.filter { todo in
                        todo.id != id
                    }
                    self?.todosRelay.accept(filteredTodos ?? [])
                }
                 */
                
                // MARK: - Rx방식2(클로저로 전달안하고 싶으면 옵저버블 사용하면 된다)
                cell.deleteActionObservable
                    .withUnretained(self)
                    .map { vc, id -> [Todo] in
                        let currentTodos = self.todosRelay.value
                        let filteredTodos = currentTodos.filter { todo in
                            todo.id != id
                        }
                        return filteredTodos
                    }
                    .bind(onNext: self.todosRelay.accept(_:))
                    .disposed(by: cell.disposeBag)
            
            return cell
        }
        .disposed(by: self.disposeBag)
        
        // 3초 후에 데이터를 넣는 법1
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.todosRelay.accept(Todo.getDumies(3))
        })
         */
        
        // 3초 후에 데이터를 넣는 법2
        /*
        Observable.just(())
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .map { Todo.getDumies(3) } // Observable<[Todo]>
            .bind(onNext: self.todosRelay.accept(_:))
            .disposed(by: disposeBag)
         */
        
        // 3초 후에 데이터를 넣는 법3
        /*
        Observable.just(())
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .map { Todo.getDumies(3) } // Observable<[Todo]>
            .bind(onNext: { self.todosRelay.accept($0) } )
            .disposed(by: disposeBag)
         */
        
        addButton.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                var currentTodos = self.todosRelay.value
                currentTodos.insert(Todo(), at: 0)
                self.todosRelay.accept(currentTodos)
            })
            .disposed(by: disposeBag)
        

        
    }
    
    private func makeUI() {
        [myTableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // 네비게이션 버튼
        navigationItem.rightBarButtonItems = [addButton]
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

#Preview {
    UINavigationController(rootViewController: TodosVC5())
}
