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
    
    // 주사위 관련 비즈니스 로직을 다루는 인스턴스
    var diceManager = DiceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstImageView.image = diceManager.getFirstDice()
        secondImageView.image = diceManager.getFirstDice()
    }

    @IBAction func rollButtomTapped(_ sender: UIButton) {
        // 첫번째 이미지 뷰의 이미지 랜덤으로 변경
        // firstImageView.image = diceArray[Int.random(in: 1...5)]
        firstImageView.image = diceManager.getRandomDice()
        // 두번째 이미지 뷰의 이미지 랜덤으로 변경
        // secondImageView.image = diceArray.randomElement()
        secondImageView.image = diceManager.getRandomDice()
    }
}

