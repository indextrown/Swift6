//
//  TodoCell.swift
//  RxTodoList
//
//  Created by 김동현 on 4/13/25.
//

import UIKit

class TodoCell: UITableViewCell {

    
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var isDoneSwitch: UISwitch!
    
    var indexPath: IndexPath? = nil
    var isDoneAction: ((IndexPath, Bool) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isDoneSwitch.addTarget(self, action: #selector(handleIsDoneSwitch(_:)), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc fileprivate func handleIsDoneSwitch(_ sender: UISwitch) {
        // print(#fileID, #function, #line, "- sender: \(sender.isOn)")
        if let indexPath = self.indexPath {
            isDoneAction?(indexPath, sender.isOn)
        }
    }
    
}
