//
//  UITableView+Ext.swift
//  dynamic_table_view_tutorial
//
//  Created by Jeff Jeong on 2023/02/20.
//  Copyright © 2023 Tuentuenna. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func reloadDataAndKeepOffset() {
        // 스크롤링 멈추기
        setContentOffset(contentOffset, animated: false)
        
        // 데이터 추가전 컨텐트 사이즈
        let beforeContentSize = contentSize
        reloadData()
        layoutIfNeeded()
        
        // 데이터 추가후 커텐트 사이즈
        let afterContentSize = contentSize
        
        // 데이터가 변경되고 리로드 되고 나서 컨텐트 옵셋 계산
        let calculatedNewOffset = CGPoint(
            x: contentOffset.x + (afterContentSize.width - beforeContentSize.width),
            y: contentOffset.y + (afterContentSize.height - beforeContentSize.height)
        )
        
        // 변경된 옵셋 설정
        setContentOffset(calculatedNewOffset, animated: false)
    }
}
