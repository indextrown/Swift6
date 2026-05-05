//
//  StoryboardCell.swift
//  UITableViewTutorial
//
//  Created by 김동현 on 5/9/25.
//

import Foundation
import UIKit

//class StoryboardCell: UITableViewCell {
//    
//    // 변수로
//    //static let reuseIdentifier: String = "StoryboardCell"
//    
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var bodyLabel: UILabel!
//    
//    /// 1. 셀을 스토리보드에 추가하거나 Nib파일에 추가하게 되면 이 자체의 라이프사이클이 생긴다. awakeFromNib
//    override func awakeFromNib() {
//        /// 2. 상속을 한것이기 때문에 부모에 있는 awakeFromNib 로직을 터트려줘야한다
//        super.awakeFromNib()
//        print(#fileID, #function, #line, "- awakeFromNib()")
//        self.backgroundColor = .systemYellow
//    }
//}

//extension UITableViewCell {
//    static var reuseIdentifier: String {
//        return String(describing: Self.self) // 현재 타입.현재 타입의 타입 그자체, 현재 타입의 타입 객체(메타타입)
//    }
//}
//
//extension UICollectionView {
//    static var reuseIdentifier: String {
//        return String(describing: Self.self) // 현재 타입.현재 타입의 타입 그자체, 현재 타입의 타입 객체(메타타입)
//    }
//}

protocol ReuseIdentifiable {
    // 프로토콜에서 로직을 정의할 수 없어서 가져올 수 있도록 설정
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    // 로직에 대한 정의는 Extension에서 간능
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewHeaderFooterView : ReuseIdentifiable {}

class StoryboardCell: UITableViewCell {
    
    // 변수로
    //static let reuseIdentifier: String = "StoryboardCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    /// 1. 셀을 스토리보드에 추가하거나 Nib파일에 추가하게 되면 이 자체의 라이프사이클이 생긴다. awakeFromNib
    override func awakeFromNib() {
        /// 2. 상속을 한것이기 때문에 부모에 있는 awakeFromNib 로직을 터트려줘야한다
        super.awakeFromNib()
        print(#fileID, #function, #line, "- awakeFromNib()")
        self.backgroundColor = .systemYellow
    }
}
