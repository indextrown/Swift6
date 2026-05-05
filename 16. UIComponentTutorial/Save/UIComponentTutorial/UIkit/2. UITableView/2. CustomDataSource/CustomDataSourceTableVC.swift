//
//  CustomListVC.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/1/25.
//

import UIKit
import Fakery

// MARK: - Model
struct DummySection {
    let uuid: UUID
    let title: String
    let body: String
    let rows: [DummyData]
    
    init() {
        self.uuid = UUID()
        self.title = "섹션 타이틀입니다: \(uuid)"
        self.body = "섹션 바디입니다: \(uuid)"
        self.rows = DummyData.getDumies(10)
    }
    
    static func getDummies(_ count: Int = 10) -> [DummySection] {
        return (1...count).map { _ in DummySection() }
    }
}

// MARK: - CustomDataSource
class MyDataSource: NSObject, UITableViewDataSource {
    
    var dummySections: [DummySection] = DummySection.getDummies()
        
    override init() {
        super.init()
    }
    
    // MARK: - 섹션이 여러개일때만 사용
    /// 섹션의 타이틀 설정
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "헤더: " + dummySections[section].title
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "푸터: " + dummySections[section].title
    }
    
    // MARK: - UITableViewDataSource
    /// 하나의 섹션에 몇개의 rows가 있냐
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummySections[section].rows.count
    }
    
    /// 각 셀에 대한 내용을 구성하여 반환 -> 셀의 종류를 정하기 - 테이블뷰 셀을 만들어서 반환해라
    /// - indexPath: 셀의 위치를 나타내는 인덱스 경로
    /// - returns: 구성된 UITableViewCell 객체
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CodeCell.reuseIdentifier, for: indexPath) as? CodeCell else {
            return UITableViewCell()
        }
        let sectionData: DummySection = dummySections[indexPath.section]
        let cellData: DummyData = sectionData.rows[indexPath.row]
        
        /// 셀의 데이터를 cellData에서 가져오기
        cell.bindCell(cellData)
        
        return cell
    }
}

final class CustomDataSourceTableVC: UIViewController {
    
    private let dummies = DummyData.getDumies()
    var dataSource: MyDataSource = MyDataSource()
    
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
    }
    
    private func settingTableView() {
        self.tableView.register(CodeCell.self, forCellReuseIdentifier: CodeCell.reuseIdentifier)
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
    }
    
    private func makeUI() {
        view.backgroundColor = .white
        [tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

/// 이벤트 관련 부분 - 셀 선택 등 사용자 인터랙션(이벤트) 관련 처리
extension CustomDataSourceTableVC: UITableViewDelegate {
    /// 사용자가 특정 셀을 선택했을 때 호출되는 메서드
    /// - Parameters:
    ///   - tableView: 이벤트가 발생한 테이블 뷰
    ///   - indexPath: 선택된 셀의 위치
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#fileID, #function, #line, "- indexPath: \(indexPath.row)")
    }
}
