////
////  NibCell.swift
////  UIComponentTutorial
////
////  Created by 김동현 on 6/14/25.
////
//
//import UIKit
//
//protocol Nibbed {
//    static var uinib: UINib { get }
//}
//
//extension Nibbed {
//    static var uinib: UINib {
//        return UINib(nibName: String(describing: Self.self), bundle: nil)
//    }
//}
//
//extension UITableViewCell: Nibbed {}
//
//class NibCell: UITableViewCell {
//    
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var bodyLabel: UILabel!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.backgroundColor = .white
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
//}
