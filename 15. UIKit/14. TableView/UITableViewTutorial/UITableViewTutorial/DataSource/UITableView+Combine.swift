//
//  UITableView+Combine.swift
//  UITableViewTutorial
//
//  Created by 김동현 on 5/15/25.
//

import UIKit
import Combine

// MARK: - Sink 정의를 보면 매개변수로 (Self.Output) -> Void) 형태의 클로저를 받는다. 이 형태를 만족하는 로직 함수를 만들자.
// public func sink(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable
extension UITableView {
    // 고차함수 - 클로저를 매개변수로 가지거나 반환을 가지는 함수 자체
    // (Self.Output) -> Void)
    // ([DummyData]) -> Void
    // 데이터소스 바인딩
//    func customItems_save() -> ([DummyData]) -> Void {
//        let dataSource = CustomCombineDataSource()
//        return { (updatedDateLisst: [DummyData]) in
//            dataSource.pushDataList(updatedDateLisst, to: self) // 리로드
//        }
//    }
    
    
    func customItems<Item>() -> ([Item]) -> Void {
        let dataSource = CustomCombineDataSource<Item>()
        return { (updatedDateLisst: [Item]) in
            dataSource.pushDataList(updatedDateLisst, to: self) // 리로드
        }
    }
    
    func customItemsWithCell<Item>(
        makeCell: ((UITableView, IndexPath, Item) -> UITableViewCell)? = nil
    ) -> ([Item]) -> Void {
        let dataSource = CustomCombineDataSource<Item>(makeCell)
        return { (updatedDateLisst: [Item]) in
            dataSource.pushDataList(updatedDateLisst, to: self) // 리로드
        }
    }
}


