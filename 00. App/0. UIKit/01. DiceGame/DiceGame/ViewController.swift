//
//  ViewController.swift
//  DiceGame
//
//  Created by 김동현 on 2/13/25.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    
    // #imageLiteral( 치면됨
    var diceArray: [UIImage] = [#imageLiteral(resourceName: "black1"), #imageLiteral(resourceName: "black2"), #imageLiteral(resourceName: "black3"), #imageLiteral(resourceName: "black4"), #imageLiteral(resourceName: "black5"), #imageLiteral(resourceName: "black6")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func rollButtomTapped(_ sender: UIButton) {
        // 첫번째 이미지 뷰의 이미지 랜덤으로 변경
        firstImageView.image = diceArray[Int.random(in: 1...5)]
        // 두번째 이미지 뷰의 이미지 랜덤으로 변경
        secondImageView.image = diceArray.randomElement()
    }
}

