//
//  CellConfigTableViewCell.swift
//  UITableViewTutorial
//
//  Created by 김동현 on 5/12/25.
//

import UIKit

// 기존 테이블뷰 셀은 데이터만 신경쓰면 됨
class CellConfigTableViewCell: UITableViewCell {
    
    // 데이터 변경시 UI 변경해라
    var title: String = "" {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    var body: String = "" {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }

    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var contentConfig = MyCellConfiguration().updated(for: state)
        contentConfig.title = title
        contentConfig.body = body
        self.contentConfiguration = contentConfig
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

#if DEBUG
import SwiftUI

struct CellConfigTableViewCell_PreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        CodeCell().getPreview()
            .previewLayout(.fixed(width: 200, height: 100))
    }
}
#endif
