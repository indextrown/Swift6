//
//  StoryboardListViewController.swift
//  UITableViewTutorial
//
//  Created by 김동현 on 5/8/25.
//

//import UIKit
//
//class StoryboardListViewController: UIViewController {
//
//    @IBOutlet weak var myTableView: UITableView!
//    
//    var dummySections: [DummySection] = DummySection.getDummies(10)
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.myTableView.dataSource = self
//        self.myTableView.delegate = self
//    }
//}
//
///// UITableView의 데이터 관리 역할을 담당
//extension StoryboardListViewController: UITableViewDataSource {
//    
//    /// 섹션이 여러개일때만 사용
//    /// 섹션의 타이틀 설정
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "헤더: " + dummySections[section].title
//    }
//    
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return "푸터: " + dummySections[section].title
//    }
//    
//    /// 섹션이 여러개일때만 사용
//    /// 현재 섹션이 몇개인지
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return dummySections.count
//    }
//    
//    /// 하나의 섹션에 몇개의 rows가 있냐
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dummySections[section].rows.count
//    }
//    
//    /// 각 셀에 대한 내용을 구성하여 반환 -> 셀의 종류를 정하기 - 테이블뷰 셀을 만들어서 반환해라
//    /// - indexPath: 셀의 위치를 나타내는 인덱스 경로
//    /// - returns: 구성된 UITableViewCell 객체
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        /// 기본 스타일의 셀 생성 (textLabel과 detailTextLabel 포함)
//        /// let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MyCell")
//        
//        // [guard let] 방식
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardCell.reuseIdentifier, for: indexPath) as? StoryboardCell else {
//            return UITableViewCell()
//        }
//        
//        let sectionData: DummySection = dummySections[indexPath.section]
//        
//        let cellData: DummyData = sectionData.rows[indexPath.row]
//        
//        /// 셀의 주 텍스트를 더미 데이터에서 가져오기
//        cell.titleLabel.text = cellData.title
//        
//        /// 셀의 서브 타이틀 설정
//        cell.bodyLabel.text = cellData.body
//        
//        //cell.detailTextLabel?.numberOfLines = 0
//        return cell
//        
//        /*
//        [if let] 방식
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "StoryBoardCell", for: indexPath) as? StoryboardCell {
//            let sectionData: DummySection = dummySections[indexPath.section]
//            
//            let cellData: DummyData = sectionData.rows[indexPath.row]
//            
//            /// 셀의 주 텍스트를 더미 데이터에서 가져오기
//            cell.titleLabel.text = cellData.title
//            
//            /// 셀의 서브 타이틀 설정
//            cell.bodyLabel.text = cellData.body
//            
//            //cell.detailTextLabel?.numberOfLines = 0
//            return cell
//        } else {
//            return UITableViewCell()
//        }
//        */
//    }
//}
//
///// 이벤트 관련 부분 - 셀 선택 등 사용자 인터랙션(이벤트) 관련 처리
//extension StoryboardListViewController: UITableViewDelegate {
//    /// 사용자가 특정 셀을 선택했을 때 호출되는 메서드
//    /// - Parameters:
//    ///   - tableView: 이벤트가 발생한 테이블 뷰
//    ///   - indexPath: 선택된 셀의 위치
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(#fileID, #function, #line, "- indexPath: \(indexPath.row)")
//    }
//}

import UIKit

class StoryboardListViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    var dataSource: MyDataSource = MyDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.dataSource = dataSource
        self.myTableView.delegate = self
    }
}

/// 이벤트 관련 부분 - 셀 선택 등 사용자 인터랙션(이벤트) 관련 처리
extension StoryboardListViewController: UITableViewDelegate {
    /// 사용자가 특정 셀을 선택했을 때 호출되는 메서드
    /// - Parameters:
    ///   - tableView: 이벤트가 발생한 테이블 뷰
    ///   - indexPath: 선택된 셀의 위치
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#fileID, #function, #line, "- indexPath: \(indexPath.row)")
    }
}
