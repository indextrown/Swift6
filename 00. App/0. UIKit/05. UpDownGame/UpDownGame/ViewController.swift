//
//  ViewController.swift
//  UpDownGame
//
//  Created by 김동현 on 2/13/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    var comNum = Int.random(in: 1...10)
    var myNumber: Int = 1
    
    // 앱의 화면에 들어오면 가장 처음에 실행되는 함수
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1) 메인레이블에 "선택하세요"
        mainLabel.text = "선택하세요"
        // 2) 숫자레이블은 ""
        numberLabel.text = ""
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        // 1) 버튼의 숫자를 가져오자
        guard let numstring = sender.currentTitle else { return }
        
        // 2) numberLabel이 변하도록(숫자에 따라)
        numberLabel.text = numstring
        
        // 3) 선택한 숫자를 변수에다가 저장(선택사항)
        guard let num = Int(numstring) else { return }
        myNumber = num
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        // 1) 메인레이블 "선택하세요"
        mainLabel.text = "선택하세요"
        // 2) 컴퓨터의 랜덤숫자를 다시 선택하도록
        comNum = Int.random(in: 1...10)
        // 3) 숫자레이블을 ""
        numberLabel.text = ""
    }
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        // 1) 컴퓨터의 숫자와 내가 선택한 숫자를 비교 UP / Down / Bingo인지를 mainLabel에 표시
        
        // myNumber 변수 없이 하는법
        // guard let myNumString = numberLabel.text else { return }
        // guard let myNum = Int(myNumString) else { return }
        
        if comNum > myNumber {
            mainLabel.text = "Up"
        } else if comNum < myNumber {
            mainLabel.text = "Down"
        } else {
            mainLabel.text = "Bingo👍"
        }
    }
    
}

