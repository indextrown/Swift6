//
//  ControlExtension.swift
//  LBSRiders
//
//  Created by 김동현 on 7/7/25.
//

import UIKit

extension UIControl {
    @discardableResult
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) -> Self {
        self.addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
        return self
    }
}
