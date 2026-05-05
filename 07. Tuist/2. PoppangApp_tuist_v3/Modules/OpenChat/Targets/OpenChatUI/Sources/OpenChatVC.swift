//
//  OpenChatViewController.swift
//  OpenChat
//
//  Created by 김동현 on 12/12/25.
//  Copyright © 2025 tuist.io. All rights reserved.
//

import UIKit

public class OpenChatVC: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ") 
    }
    
    public class func getInstanc() -> OpenChatVC {
        let storyboard = UIStoryboard(name: "OpenChatVC",
                                      bundle: Bundle(for: OpenChatVC.self))
        return storyboard.instantiateInitialViewController() as! OpenChatVC
    }
}
