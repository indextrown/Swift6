//
//  DetailVC.swift
//  dynamic_table_view_tutorial
//
//  Created by Jeff Jeong on 2023/02/20.
//  Copyright © 2023 Tuentuenna. All rights reserved.
//

import Foundation
import UIKit

class DetailVC : UIViewController {
    
    @IBOutlet weak var injectedDataLabel: UILabel?
    
    var injectedData: String? = nil
    
    init?(coder: NSCoder, with injectedData: String) {
        self.injectedData = injectedData
        super.init(coder: coder)
        print(#fileID, #function, #line, "- ")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print(#fileID, #function, #line, "- ")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        self.navigationItem.title = injectedData
        injectedDataLabel?.text = injectedData
    }
    
}
