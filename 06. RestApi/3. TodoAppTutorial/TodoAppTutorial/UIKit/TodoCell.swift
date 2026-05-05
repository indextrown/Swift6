//
//  TodoCell.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 3/24/25.
//

import UIKit

final class TodoCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var contentLabel: UILabel!
    
    @IBOutlet weak var selectionSwitch: UISwitch!
    
    var cellData: Todo? = nil
    
    // 삭제 액션
    var onDeleteActionEvent: ((Int) -> Void)? = nil
    
    // 수정 액션
    var onEditActionEvent: ((_ id: Int, _ title: String) -> Void)? = nil
    
    // 선택 액션
    var onSelectedActionEvent: ((_ id: Int, _ isOn: Bool) -> Void)? = nil
    
    // UI 업데이트(셀에 대한 데이터)
    /// 셀 데이터 적용
    /// - Parameter cellData: 셀 데이터
    func updateUI(_ cellData: Todo, _ selectedTodoIds: Set<Int>) {
        guard let id = cellData.id, let title = cellData.title else { return }
        
        self.cellData = cellData
        self.titleLabel.text = "아이디: \(id)"
        self.contentLabel.text = title
        self.selectionSwitch.isOn = selectedTodoIds.contains(cellData.id ?? 0)// cellData.isDone ?? false
    }
    
    // Nib파일이나 Storyboard에서 사용이 될 때 얘가 탄다
    override func awakeFromNib() {
        print(#fileID, #function, #line, "- ")
        selectionSwitch.addTarget(self, action: #selector(onSelectionChanged), for: .valueChanged)
    }
    
    @objc fileprivate func onSelectionChanged(_ sender: UISwitch) {
        print(#fileID, #function, #line, "- sender.isOn: \(sender.isOn)")
        guard let id = cellData?.id else { return }
        self.onSelectedActionEvent?(id, sender.isOn)
    }
    
    @IBAction func onEditButtonClicked(_ sender: UIButton) {
        print(#fileID, #function, #line, "- ")
        guard let id = cellData?.id,
              let title = cellData?.title else { return }
        self.onEditActionEvent?(id, title)
    }
    
    @IBAction func onDeleteButtonClicked(_ sender: Any) {
        print(#fileID, #function, #line, "- ")
        guard let id = cellData?.id else { return }
        self.onDeleteActionEvent?(id)
    }
}
