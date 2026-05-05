//
//  Storyboared.swift
//  RxFlowTutorialTest
//
//  Created by Jeff Jeong on 2023/07/16.
//

import Foundation
import UIKit

protocol StoryBoarded {
    static func instantiate(_ storyboardName: String?) -> Self
}

extension StoryBoarded where Self: UIViewController {
    static func instantiate(_ storyboardName: String? = nil) -> Self {
        let storyboard = UIStoryboard(name: storyboardName ?? String(describing: self), bundle: Bundle.main)
        return storyboard.instantiateViewController(identifier: String(describing: self)) as! Self
    }
}

extension UIViewController : StoryBoarded {}
