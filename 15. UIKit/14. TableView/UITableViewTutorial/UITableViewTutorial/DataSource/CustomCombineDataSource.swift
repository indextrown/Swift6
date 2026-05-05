//
//  CustomCombineDataSource.swift
//  UITableViewTutorial
//
//  Created by 김동현 on 5/15/25.
//
// https://www.youtube.com/watch?v=vlJ392OMkoI&list=PLgOlaPUIbynpuq9GKCwAedgWkkPm2Wo8v&index=16

import UIKit

/*
class CustomCombineDataSource<T, G>: NSObject, UITableViewDataSource {
    
    // 멤버 변수
    var dataList: [T] = []
    
    var testDataList: [G] = []
*/

class CustomCombineDataSource<Item>: NSObject, UITableViewDataSource {
    
    // 셀을 만드는 클로저
    // 1. let makeCell: (_ tableView: UITableView, _ indexPath: IndexPath, _ cellData: Item) -> UITableViewCell
    // 2. let makeCell: (UITableView, IndexPath, Item) -> UITableViewCell // 위랑 같음
    // 3.
    var makeCell: ((UITableView, IndexPath, Item) -> UITableViewCell)? = nil // 옵셔널로도 가능
    
    var dataList: [Item] = []
    
    // 2. 안쪽에서 터트리기 때문에 escaping 해주자
    /*
    init(makeCell: @escaping (_ tableView: UITableView, _ indexPath: IndexPath, _ cellData: Item) -> UITableViewCell) {
        self.makeCell = makeCell
        super.init()
    }
     */
    
    // 3.
    init(_ makeCell: ((_ tableView: UITableView, _ indexPath: IndexPath, _ cellData: Item) -> UITableViewCell)? = nil) {
        self.makeCell = makeCell
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

    /// 각 셀에 대한 내용을 구성하여 반환 -> 셀의 종류를 정하기 - 테이블뷰 셀을 만들어서 반환해라
    /// - indexPath: 셀의 위치를 나타내는 인덱스 경로
    /// - returns: 구성된 UITableViewCell 객체
    /// 어떤 셀을 보여줄지
    // 1. 테이블뷰
    // 2. indexPath 몇번째인지
    // 3. 셀에 대한 데이터 - 셀에 대한 제네릭 데이터
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 비어있으면 기본 UITableViewCell 반환
        makeCell?(tableView, indexPath, dataList[indexPath.row]) ?? UITableViewCell()
        
        
    }
}




