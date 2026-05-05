//
//  ViewController.swift
//  RPSGame
//
//  Created by 김동현 on 2/13/25.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - 변수 / 속성
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var comImageView: UIImageView!
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var comChoiceLabel: UILabel!
    @IBOutlet weak var myChoiceLabel: UILabel!
    
    var comChoice: RPS = RPS(rawValue: Int.random(in: 0...2))!
    var myChocie: RPS = RPS.rock
    
    // MARK: - 함수 / 메서드
    // viewDidLoad: 앱 화면에 들어오면 처음 실행되는 함수
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1) 첫번째/두번쨰 이미지뷰에 이미지를 띄워야 함
        comImageView.image = #imageLiteral(resourceName: "ready")
        myImageView.image = UIImage(named: "ready.png")
        // myImageView.image = UIImage.ready
        
        
        // 2) 첫번째/두번쨰 레이블에 "준비" 라고 문자열을 띄워야 함
        comChoiceLabel.text = "준비"
        myChoiceLabel.text = "준비"
    }

    // 가위 바위 보를 눌러도 이 함수가 실행됨(버튼 3개 -> 함수 하나로 선택)
    @IBAction func rpsButtonTapped(_ sender: UIButton) {
        // 가위/바위/보를 선택하여 그 정보를 저장해야 한다
        
        guard let title = sender.currentTitle else { return }
   
        switch title {
        case "가위":
            // 가위 열거형을 만들어서 저장
            myChocie = RPS.scissors
        case "바위":
            // 바위 열거형을 만들어서 저장
            myChocie = RPS.rock
        case "보":
            // 보 열거형을 만들어서 저장
            myChocie = RPS.paper
        default:
            break
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        // 1) 컴퓨터가 다시 준비 이미지뷰에 표시
        // 2) 컴퓨터가 다시 준비 레이블에 표시
        comImageView.image = #imageLiteral(resourceName: "ready")
        comChoiceLabel.text = "준비"
        
        // 3) 내 선택 이미지뷰에도 준비 이미지를 표시
        // 4) 내 선택 레이블에도 준비 문자열 표시
        myImageView.image = #imageLiteral(resourceName: "ready")
        myChoiceLabel.text = "준비"
        
        // 5) 메인 레이블 "선택하세요" 표시
        mainLabel.text = "선택하세요"
        
        // 컴퓨터가 다시 랜덤 가위/바위/보를 선택하고 저장
        comChoice = RPS(rawValue: Int.random(in: 0...2))!
    }
    
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        // 1) 컴퓨터가 랜덤 선택한 것을 이미지뷰에 표시
        // 2) 컴퓨터가 랜덤 선택한 것을 레이블에 표시
        switch comChoice {
        case .rock:
            comImageView.image = #imageLiteral(resourceName: "rock")
            comChoiceLabel.text = "바위"
        case .paper:
            comImageView.image = #imageLiteral(resourceName: "paper")
            comChoiceLabel.text = "보"
        case .scissors:
            comImageView.image = #imageLiteral(resourceName: "scissors")
            comChoiceLabel.text = "가위"
        }
        
        // 3) 내가 랜덤 선택한 것을 이미지뷰에 표시
        // 4) 내가 랜덤 선택한 것을 레이블에 표시
        switch myChocie {
        case .rock:
            myImageView.image = #imageLiteral(resourceName: "rock")
            myChoiceLabel.text = "바위"
        case .paper:
            myImageView.image = #imageLiteral(resourceName: "paper")
            myChoiceLabel.text = "보"
        case .scissors:
            myImageView.image = #imageLiteral(resourceName: "scissors")
            myChoiceLabel.text = "가위"
        }
        
        // 5) 컴퓨터가 선택한 것과 내가 선택한 것을 비교해서 이겼는지 졌는지 판단 표시
        if comChoice == myChocie {
            mainLabel.text = "비겼다"
        } else if comChoice == .rock && myChocie == .paper {
            mainLabel.text = "이겼다"
        } else if comChoice == .scissors && myChocie == .rock {
            mainLabel.text = "이겼다"
        } else {
            mainLabel.text = "졌다"
        }
    }
}

