//
//  CustomHeaderView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 8/8/25.
//

import UIKit

final class CustomHeaderView: UITableViewHeaderFooterView {
    

    @IBOutlet weak var headerTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(#fileID, #function, #line, "- ")
        
        // ✅ 배경색을 설정하려면 이렇게 해야 함
       let bgView = UIView()
       bgView.backgroundColor = .systemYellow // 원하는 색상
       self.backgroundView = bgView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        let transition = CATransition()
        transition.duration = 1.0
        transition.type = .reveal
        self.layer.add(transition, forKey: nil)
    }
}
