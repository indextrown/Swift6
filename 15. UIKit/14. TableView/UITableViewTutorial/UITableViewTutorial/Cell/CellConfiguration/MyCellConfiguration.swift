//
//  MyCellConfiguration.swift
//  UITableViewTutorial
//
//  Created by 김동현 on 5/12/25.
//

import UIKit

// 커스텀 셀에 대한 설정
struct MyCellConfiguration: UIContentConfiguration, Hashable {
    
    var title: String = ""
    var body: String = ""
    
    // 보여줄 화면
    // UIView이면서 UIContentView인 애를 반화내라
    func makeContentView() -> any UIView & UIContentView {
        return CellConfigurationView(config: self)
    }
    
    
    /// 셀 상태가 변경되면 발동
    /// - Parameter state: 셀 상태
    /// - Returns: 셀 설정 자체
    func updated(for state: any UIConfigurationState) -> MyCellConfiguration {
        if let state = state as? UICellConfigurationState {
            var updatedConfig = self
            
            if state.isSelected {
                updatedConfig.title = "선택됨: " + updatedConfig.title
            }
            return updatedConfig
        }
        return self
    }
}
