//
//  DiffableDataSourceListVC.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/14/25.
//
// https://www.youtube.com/watch?v=1Ar-xtSCLRU&list=PLgOlaPUIbynpuq9GKCwAedgWkkPm2Wo8v&index=22

import UIKit

final class DiffableDataSourceListVC: UIViewController {
    
    private lazy var myTableView = UITableView(frame: .zero, style: .grouped)
    
    var sections: [DiffableDummySection] = DiffableDummySection.getDummies(1)
    
    var snapshot = NSDiffableDataSourceSnapshot<DiffableDummySection, DiffableDummyData>()
    
    var dataSource: UITableViewDiffableDataSource<DiffableDummySection, DiffableDummyData>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        
        myTableView.delegate = self
        
        makeUI()
        makeCell() 
    }
    
    private func makeUI() {
        self.view.backgroundColor = .white
        self.title = "123"
        
        view.addSubview(myTableView)
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myTableView.topAnchor.constraint(equalTo: view.topAnchor),
            myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            myTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func makeCell() {
        
        myTableView.register(DiffCodeCell.self, forCellReuseIdentifier: DiffCodeCell.reuseIdentifier)
        
        self.dataSource = makeDiffableDataSource()
        
        // 1. 스냅샷 준비
        snapshot.appendSections(sections)
        sections.forEach { aSection in
            snapshot.appendItems(aSection.rows, toSection: aSection)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func makeDiffableDataSource() -> UITableViewDiffableDataSource<DiffableDummySection, DiffableDummyData> {
        return UITableViewDiffableDataSource<DiffableDummySection, DiffableDummyData>(tableView: myTableView) { tableView, indexPath, itemIdentifier -> UITableViewCell in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DiffCodeCell.reuseIdentifier, for: indexPath) as? DiffCodeCell else { return UITableViewCell() }
            
            
            cell.titleLabel.text = itemIdentifier.title
            cell.bodyLabel.text = itemIdentifier.body
            
            return cell
        }
    }
}

extension DiffableDataSourceListVC: UITableViewDelegate {
    // 헤더
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.text = "헤더: " + self.sections[section].title
        headerLabel.backgroundColor = .systemOrange.withAlphaComponent(0.4)
        return headerLabel
    }
    
    // 푸터
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerLabel = UILabel()
        footerLabel.text = "푸터: " + self.sections[section].title
        footerLabel.backgroundColor = .systemBlue.withAlphaComponent(0.4)
        return footerLabel
    }
    
    // 스와이프 액션(삭제)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] deleteAction, view, completionHandler in
            
            guard let self = self else { return }
            
            // 1. 삭제할 item 가져오기
            let section = self.sections[indexPath.section]
            let item = section.rows[indexPath.row]
            
            // 2. sections의 실제 데이터에서도 삭제
            if let itemIndex = self.sections[indexPath.section].rows.firstIndex(of: item) {
                self.sections[indexPath.section].rows.remove(at: itemIndex)
            }
            
            // 3. Shanshot 업데이트
            self.snapshot.deleteItems([item])
            self.dataSource?.apply(self.snapshot, animatingDifferences: true)
            
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
