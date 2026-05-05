//
//  PostDetail.swift
//  RxFlowTutorialTest
//
//  Created by Jeff Jeong on 2023/07/16.
//

import UIKit

class PostDetailVC: UIViewController {

    @IBOutlet weak var receivedDataLabel: UILabel!
    
    var receivedData: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        receivedDataLabel.text = receivedData
    }
}
