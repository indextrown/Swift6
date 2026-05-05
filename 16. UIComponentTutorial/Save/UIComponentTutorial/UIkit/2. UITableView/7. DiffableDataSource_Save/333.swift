////
////  DiffableDataSourceListVC.swift
////  UIComponentTutorial
////
////  Created by 김동현 on 6/14/25.
////
//
//import UIKit
//
//final class DiffableDataSourceListVC: UIViewController {
//    
//    @IBOutlet weak var myTableView: UITableView!
//    
//    var sections: [DiffableDummySection] = DiffableDummySection.getDummies()
//    
//    var snapshot = NSDiffableDataSourceSnapshot<DiffableDummySection, DiffableDummyData>()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print(#fileID, #function, #line, "- ")
//        
//        if myTableView == nil {
//            print("❗️myTableView is nil – VC가 코드로 생성되었을 수 있습니다.")
//        }
//
//        makeUI()
//        makeCell() 
//    }
//    
//    private func makeUI() {
//        self.view.backgroundColor = .white
//        self.title = "123"
//    }
//    
//    private func makeCell() {
//        let cellNib = UINib(nibName: "NibCell", bundle: nil)
//        myTableView.register(cellNib, forCellReuseIdentifier: NibCell.reuseIdentifier)
//        
//        let dataSource = UITableViewDiffableDataSource<DiffableDummySection, DiffableDummyData>(tableView: myTableView) { tableView, indexPath, itemIdentifier -> UITableViewCell in
//            
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: NibCell.reuseIdentifier, for: indexPath) as? NibCell else { return UITableViewCell() }
//            
//            cell.titleLabel.text = itemIdentifier.title
//            cell.bodyLabel.text = itemIdentifier.body
//            
//            return cell
//        }
//        
//        // 1. 스냅샷 준비
//        snapshot.appendSections(sections)
//        sections.forEach { aSection in
//            snapshot.appendItems(aSection.rows, toSection: aSection)
//        }
//        dataSource.apply(snapshot, animatingDifferences: true)
//    }
//}
