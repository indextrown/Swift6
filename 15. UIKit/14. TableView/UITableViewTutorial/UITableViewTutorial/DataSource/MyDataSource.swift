//
//  MyDataSource.swift
//  UITableViewTutorial
//
//  Created by 김동현 on 5/13/25.
//

import UIKit

class MyDataSource: NSObject, UITableViewDataSource {
    
    enum ListType {
        case storyboard
        case nib
        case code
        case cellConfig
    }
    
    var listType: ListType = .storyboard
    
    var dummySections: [DummySection] = DummySection.getDummies(10)
    
    override init() {
        super.init()
    }
    
    convenience init(type: ListType = .storyboard) {
        self.init()
        self.listType = type
    }
    
    // MARK: - 셀을 등록하는 소스 관련
    /// 셀을 등록
    /// 스토리보드에서 셀을 추가하면 Xcode가 내부적으로 셀을 자동 등록한다
    /// 이코드가 자동 등록된다고 생각 tableView.dequeueReusableCell(withIdentifier: "StoryboardCell")
    /// - Parameter tableView: 등록할 테이블뷰
    func registerCells(with tableView: UITableView) {
        /// Nib 방식으로 만든 셀(NibCell.xib 파일)을 테이블 뷰에 등록
        /// - NibCell.uinib : UINib(nibName: "NibCell", bundle: nil) 을 반환
        /// - NibCell.reuseIdentifier : "NibCell" 문자열을 반환 (보통 클래스명을 기반으로 자동 생성)
        /// → 이후 dequeue 시 이 identifier로 셀을 재사용할 수 있게 됨
        /// tableView.register(NibCell.uinib, forCellReuseIdentifier: NibCell.reuseIdentifier)
        
        /// 코드로만 구현된 셀 클래스를 테이블 뷰에 등록
        /// - CellConfigTableViewCell.self : 클래스 자체를 등록
        /// - reuseIdentifier : "CellConfigTableViewCell" 문자열
        /// → register(class:) 방식은 .xib 없이 순수 코드로 UI 구성한 셀에 사용
        /// tableView.register(CellConfigTableViewCell.self, forCellReuseIdentifier: CellConfigTableViewCell.reuseIdentifier)
        switch listType {
        case .nib:
            tableView.register(NibCell.uinib, forCellReuseIdentifier: NibCell.reuseIdentifier)
            
        case .code:
            tableView.register(CodeCell.self, forCellReuseIdentifier: CodeCell.reuseIdentifier)
            
        case .cellConfig:
            tableView.register(CellConfigTableViewCell.self, forCellReuseIdentifier: CellConfigTableViewCell.reuseIdentifier)
            
        case .storyboard:
            // ❌ 스토리보드는 register 필요 없음!
            break
        }
    }
    
    // MARK: -  테이블뷰 데이터 소스 관련
    /// 섹션이 여러개일때만 사용
    /// 섹션의 타이틀 설정
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "헤더: " + dummySections[section].title
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "푸터: " + dummySections[section].title
    }
    
    /// 섹션이 여러개일때만 사용
    /// 현재 섹션이 몇개인지
    func numberOfSections(in tableView: UITableView) -> Int {
        return dummySections.count
    }
    
    /// 하나의 섹션에 몇개의 rows가 있냐
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummySections[section].rows.count
    }
    
    /// 각 셀에 대한 내용을 구성하여 반환 -> 셀의 종류를 정하기 - 테이블뷰 셀을 만들어서 반환해라
    /// - indexPath: 셀의 위치를 나타내는 인덱스 경로
    /// - returns: 구성된 UITableViewCell 객체
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// 기본 스타일의 셀 생성 (textLabel과 detailTextLabel 포함)
        /// let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MyCell")
        
        // [guard let] 방식
        
        switch listType {
        case .storyboard:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardCell.reuseIdentifier, for: indexPath) as? StoryboardCell else {
                return UITableViewCell()
            }
            let sectionData: DummySection = dummySections[indexPath.section]
            let cellData: DummyData = sectionData.rows[indexPath.row]
            cell.titleLabel.text = cellData.title /// 셀의 주 텍스트를 더미 데이터에서 가져오기
            cell.bodyLabel.text = cellData.body   /// 셀의 서브 타이틀 설정
            return cell
        case .nib:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NibCell.reuseIdentifier, for: indexPath) as? NibCell else {
                return UITableViewCell()
            }
            let sectionData: DummySection = dummySections[indexPath.section]
            let cellData: DummyData = sectionData.rows[indexPath.row]
            cell.titleLabel.text = cellData.title /// 셀의 주 텍스트를 더미 데이터에서 가져오기
            cell.bodyLabel.text = cellData.body   /// 셀의 서브 타이틀 설정
            return cell
        case .code:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CodeCell.reuseIdentifier, for: indexPath) as? CodeCell else {
                return UITableViewCell()
            }
            let sectionData: DummySection = dummySections[indexPath.section]
            let cellData: DummyData = sectionData.rows[indexPath.row]
            cell.titleLabel.text = cellData.title /// 셀의 주 텍스트를 더미 데이터에서 가져오기
            cell.bodyLabel.text = cellData.body   /// 셀의 서브 타이틀 설정
            return cell
        case .cellConfig:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellConfigTableViewCell.reuseIdentifier, for: indexPath) as? CellConfigTableViewCell else {
                return UITableViewCell()
            }
            let sectionData: DummySection = dummySections[indexPath.section]
            let cellData: DummyData = sectionData.rows[indexPath.row]
            cell.title = cellData.title
            cell.body = cellData.body
            return cell
        }
    }
}

