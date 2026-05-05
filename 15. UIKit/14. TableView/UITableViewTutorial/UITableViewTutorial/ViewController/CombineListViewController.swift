//
//  CombineListViewController.swift
//  UITableViewTutorial
//
//  Created by 김동현 on 5/13/25.
//

import UIKit
import Combine

class CombineListViewController: UIViewController {
    
    // Combine 메모리 처리를 위해 생성
    var subscriptions = Set<AnyCancellable>()
    
    // Published를 하게 되면 dummies 데이터가 추가나 값 변경시 이벤트를 받을 수 있다.
    @Published var dummies: [DummyData] = []
    @Published var indexDatas: [IndexData] = []
    
    @IBOutlet weak var myTableView: UITableView!

   
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        
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
        /*
         기존 방식
         $dummies
             .receive(on: DispatchQueue.main)
             // 데이터 변경시마다 동작
             .sink(receiveValue: { (changedDummies: [DummyData]) in
                 print("changedDummies: \(changedDummies.count)")
                 
                 // sink는 메인스레드에서 동작해서 Dispatch안해도된다
                 self.myTableView.reloadData()
             })
             .store(in: &subscriptions)
         */
        
        $dummies.receive(on: DispatchQueue.main)
            .sink(receiveValue: self.myTableView.customItemsWithCell(
                // 셀에 대한 종류를 정해주기 위해 바깥으로 뺀 형태 -> makeCell을 데이터 타입마다 다르게 정의할 수 있다
                makeCell: { myTableView, indexPath, cellData in
                
                // [guard let] 방식
                guard let cell = myTableView.dequeueReusableCell(withIdentifier: CodeCell.reuseIdentifier, for: indexPath) as? CodeCell else {
                    return UITableViewCell()
                }
        
                cell.titleLabel.text = cellData.title  // 셀의 주 텍스트를 더미 데이터에서 가져오기
                cell.bodyLabel.text = cellData.body // 셀의 서브 타이틀 설정
                cell.detailTextLabel?.numberOfLines = 0
                return cell
                
            }))
            .store(in: &subscriptions)
        
        
        // 2초 뒤에 더미데이터 10개 추가
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
            self.dummies += DummyData.getDumies(10)
            // self.indexDatas += IndexData.getDumies(10)
        })
    }
    
    fileprivate func configureTableView() {
        
        // CodeCell에서는 이 줄만 필요
        self.myTableView.register(CodeCell.self, forCellReuseIdentifier: CodeCell.reuseIdentifier)
        // self.myTableView.delegate = self
    }
}







///// UITableView의 데이터 관리 역할을 담당
//extension CombineListViewController: UITableViewDataSource {
//
//    /// 하나의 섹션에 몇개의 rows가 있냐
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dummies.count
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
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: CodeCell.reuseIdentifier, for: indexPath) as? CodeCell else {
//            return UITableViewCell()
//        }
//
//        let cellData: DummyData = dummies[indexPath.row]
//
//        /// 셀의 주 텍스트를 더미 데이터에서 가져오기
//        cell.titleLabel.text = cellData.title
//
//        /// 셀의 서브 타이틀 설정
//        cell.bodyLabel.text = cellData.body
//
//        cell.detailTextLabel?.numberOfLines = 0
//        return cell
//    }
//}

///// 이벤트 관련 부분 - 셀 선택 등 사용자 인터랙션(이벤트) 관련 처리
//extension CombineListViewController: UITableViewDelegate {
//    /// 사용자가 특정 셀을 선택했을 때 호출되는 메서드
//    /// - Parameters:
//    ///   - tableView: 이벤트가 발생한 테이블 뷰
//    ///   - indexPath: 선택된 셀의 위치
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(#fileID, #function, #line, "- indexPath: \(indexPath.row)")
//    }
//}
