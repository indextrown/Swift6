//
//  Storyboarded+Extension.swift
//  TodoAppTutorial
//
//  Created by 김동현 on 4/6/25.
//

import UIKit

extension UIViewController: StoryBoarded {}

// extension MainVC: StoryBoarded { }
// 해당하는 스토리보드 이름으로 뷰컨트롤러를 생성해주는 프로토콜
protocol StoryBoarded {
    static func instantiate(_ storyboardName: String?) -> Self
}

// 로직 정의
extension StoryBoarded {
    static func instantiate(_ storyboardName: String? = nil) -> Self {
        let name = storyboardName ?? String(describing: self)
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! Self
    }
}
