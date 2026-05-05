//
//  SecondViewController.swift
//  BMI
//
//  Created by 김동현 on 2/19/25.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var bmiNumberLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    var bmiNumber: Double?
    var adviceString: String?
    var bmiColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainUI()
    }
    
    private func mainUI() {
        
        bmiNumberLabel.clipsToBounds = true
        bmiNumberLabel.layer.cornerRadius = 5
        bmiNumberLabel.backgroundColor = .gray
        
        backButton.clipsToBounds = true
        backButton.layer.cornerRadius = 5
        backButton.setTitle("다시 계산하기", for: .normal)
        
        // bmi가 존재하면 텍스트설정, 그렇지않다면 그냥 리턴
        guard let bmi = bmiNumber else { return }
        bmiNumberLabel.text = String(bmi)
        
        // 문자열은 벗길 필요 없다 UILabel이 옵셔널 스트링 타입이라서
        adviceLabel.text = adviceString
        bmiNumberLabel.backgroundColor = bmiColor
        
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        // dismiss는 viewController 내부에 들어있어서 self 작성은 선택사항
        self.dismiss(animated: true, completion: nil)
    } 
    
}
