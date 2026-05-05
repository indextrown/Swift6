//
//  CombineTableVC.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/1/25.
//

import UIKit
import Combine

final class CombineTableVC: UIViewController {
    
    // Combine 메모리 처리를 위해 생성
    var subscriptions = Set<AnyCancellable>()
    
    // Published를 하게 되면 dummies 데이터가 추가나 값 변경 시 이벤트를 받을 수 있다
    @Published var dummies: [DummyData] = []
    
    // MARK: - UI Component
    private let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingTableView()
        self.makeUI()
        self.constraints()
        
        /*
        - sink는 @Published가 수정된 스레드에서 실행된다
        - 그래서 Published변수 수정시 메인 스레드에서 수정해주자
        - @Published 값을 메인 스레드에서 수정하든, 백그라운드에서 수정하든, .receive(on: .main)만 붙이면 sink는 메인에서 실행되고reloadData()도 안전하게 실행된다
         */
        
        // $ 붙이면 데이터 이벤트를 받을 수 있는 상태가 됨
        // sink는 구독하는 것이다.
        // AnyCancellable 구독한다고 한다.
        // store: 구독했던거에 대한 메모리 참조가 들어오게 되는데 이를 관리하기 위해 subscriptions에 넣어준다.

        $dummies
            .receive(on: DispatchQueue.main)
            .sink { changedDummies in
                self.tableView.reloadData()
            }
            .store(in: &subscriptions)
        
        // 2초 뒤에 더미데이터 10개 추가
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
            self.dummies += DummyData.getDumies(10)
        })
    }
    
    private func makeUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func settingTableView() {
        self.tableView.register(CodeCell.self, forCellReuseIdentifier: CodeCell.reuseIdentifier)
        self.tableView.dataSource = self
    }
}


/// UITableView의 데이터 관리 역할을 담당
extension CombineTableVC: UITableViewDataSource {
    
    /// 하나의 섹션에 몇개의 rows가 있는지
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummies.count
    }
    
    /// 각 셀에 대한 내용을 구성하여 반환 -> 셀의 종류를 정하기 - 테이블뷰 셀을 만들어서 반환해라
    /// - indexPath: 셀의 위치를 나타내는 인덱스 경로
    /// - returns: 구성된 UITableViewCell 객체
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CodeCell.reuseIdentifier, for: indexPath) as? CodeCell else {
            return UITableViewCell()
        }
        
        let cellData: DummyData = dummies[indexPath.row]
        
        /// 셀의 데이터를 더미 데이터(cellData)에서 가져오기
        cell.bindCell(cellData)

        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
}

#Preview {
    CombineTableVC()
}
