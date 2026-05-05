//
//  GenericCustomCombineDataSourceVC.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/1/25.
//
/*
 코드에서 CustomCombineDataSource.swift에서 셀이 추가될 때마다 항상 if let dataList를 하면 여전히 불편하다.
 */

import UIKit
import Fakery
import Combine

// MARK: - GenericCustomDataSource
class GenericCustomCombineDataSource<Item>: NSObject, UITableViewDataSource {
    
    // 멤버 변수
    var dataList: [Item] = []
    
    override init() {
        super.init()
    }
    
    // MARK: - Combine 이벤트로 들어온 데이터랑 테이블뷰랑 연결시켜주는 지점
     
    /// 변경된 데이터를 받아서 테이블뷰에 적용한다
    /// - Parameters:
    ///   - updatedDataList: 외부에서 변경된 Combine Publisher로 들어온 데이터를 내 DataSource가 가진 data로 변경하기 위한 매개변수
    ///   - tableView: 리로드 대상 테이블뷰
    func pushDataList(_ updatedDataList: [Item], to tableView: UITableView) {
        tableView.dataSource = self
        self.dataList = updatedDataList
        tableView.reloadData()
    }
    
    // MARK: - 테이블뷰 데이터 소스 관련(변경이 된 데이터를 데이터소스로 넘겨받아서 reloadData를 하는 목적
    /// 하나의 섹션에 몇개의 rows가 있냐
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    // 어떤 셀을 보여줄 지
    /// 각 셀에 대한 내용을 구성하여 반환 -> 셀의 종류를 정하기 - 테이블뷰 셀을 만들어서 반환해라
    /// - indexPath: 셀의 위치를 나타내는 인덱스 경로 - 몇번째인지
    /// - returns: 구성된 UITableViewCell 객체
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CodeCell.reuseIdentifier, for: indexPath) as? CodeCell else {
             return UITableViewCell()
         }
        
        if let dataList = dataList as? [DummyData] {
            let cellData: DummyData = dataList[indexPath.row]
            cell.bindCell(cellData)
        }
        
        if let dataList = dataList as? [IndexData] {
            let cellData: IndexData = dataList[indexPath.row]
            cell.bindCell(cellData)
        }
        
        cell.detailTextLabel?.numberOfLines = 0
        
        return cell
    }
}

// MARK: - Sink 정의를 보면 매개변수로 (Self.Output) -> Void) 형태의 클로저를 받는다. 이 형태를 만족하는 로직 함수를 만들자.
// public func sink(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable
extension UITableView {
    // 고차함수 - 클로저를 매개변수로 가지거나 반환을 가지는 함수 자체
    // (Self.Output) -> Void)
    // ([DummyData]) -> Void
    // 데이터소스 바인딩
    func customItems<Item>() -> ([Item]) -> Void {
        let dataSource = GenericCustomCombineDataSource<Item>()
        return { (updatedDateLisst: [Item]) in
            dataSource.pushDataList(updatedDateLisst, to: self) // 리로드
        }
    }
}

final class GenericCustomCombineDataSourceVC: UIViewController {
    // Combine 메모리 처리를 위해 생성
    var subscriptions = Set<AnyCancellable>()

    // Published를 하게 되면 dummies 데이터가 추가나 값 변경시 이벤트를 받을 수 있다.
    // @Published var dummies: [DummyData] = []
    @Published var indexDatas: [IndexData] = []
    
    // MARK: - UI Component
    private let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView()
        makeUI()
        constraints()
        
        /*
        - sink는 @Published가 수정된 스레드에서 실행된다
        - 그래서 Published변수 수정시 메인 스레드에서 수정해주자
        - @Published 값을 메인 스레드에서 수정하든, 백그라운드에서 수정하든, .receive(on: .main)만 붙이면 sink는 메인에서 실행되고reloadData()도 안전하게 실행된다
        */
       
        // MARK: - 기존의 데이터를 받는 거를 CombineListViewController에서 다했더라면 이제는 customDataSource으로 따로 뺴두고, 로직은 extension으로 빼서 처리를 한 것이다.
        // $ 붙이면 데이터 이벤트를 받을 수 있는 상태가 됨
        // sink는 구독하는 것이다.
        // AnyCancellable 구독한다고 한다.
        // store: 구독했던거에 대한 메모리 참조가 들어오게 되는데 이를 관리하기 위해 subscriptions에 넣어준다.
        
        $indexDatas
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: self.tableView.customItems())
            .store(in: &subscriptions)
        
        // 2초 뒤에 더미데이터 10개 추가
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
            self.indexDatas += IndexData.getDumies(10)
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
    }
}

#Preview {
    GenericCustomCombineDataSourceVC()
}
