//
//  PreviewController.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 7/27/25.
//

import UIKit

final class TestViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
    }
}

#if DEBUG
import SwiftUI

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        TestViewController().getPreview()
            .ignoresSafeArea()
    }
}

#endif
