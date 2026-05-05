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
    
    // 가위바위보 게임(비즈니스 로직) 관리 위한 인스턴스
    var rpsManager = RPSManager()
    
    // MARK: - 함수 / 메서드
    // viewDidLoad: 앱 화면에 들어오면 처음 실행되는 함수
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        // 1) 첫번째/두번쨰 이미지뷰에 이미지를 띄워야 함
        comImageView.image = rpsManager.getReady().rpsInfo.image
        myImageView.image = rpsManager.getReady().rpsInfo.image
        
        // 2) 첫번째/두번쨰 레이블에 "준비" 라고 문자열을 띄워야 함
        comChoiceLabel.text = rpsManager.getReady().rpsInfo.name
        myChoiceLabel.text = rpsManager.getReady().rpsInfo.name
    }

    // 가위 바위 보를 눌러도 이 함수가 실행됨(버튼 3개 -> 함수 하나로 선택)
    @IBAction func rpsButtonTapped(_ sender: UIButton) {
        // 가위/바위/보를 선택하여 그 정보를 저장해야 한다
        
        guard let title = sender.currentTitle else { return }
   
        // 가져온 문자를 분기처리해서 myChoice변수에 열거형 형태로 저장
        rpsManager.userGetSelected(name: title)
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        // 1) 컴퓨터가 다시 준비 이미지뷰에 표시
        // 2) 컴퓨터가 다시 준비 레이블에 표시
        comImageView.image = rpsManager.getReady().rpsInfo.image
        comChoiceLabel.text = rpsManager.getReady().rpsInfo.name
        
        // 3) 내 선택 이미지뷰에도 준비 이미지를 표시
        // 4) 내 선택 레이블에도 준비 문자열 표시
        myImageView.image = rpsManager.getReady().rpsInfo.image
        myChoiceLabel.text = rpsManager.getReady().rpsInfo.name
        
        // 5) 메인 레이블 "선택하세요" 표시
        mainLabel.text = "선택하세요"
        
        // 6) 컴퓨터가 다시 랜덤 가위/가위/보를 선택하고 저장
        rpsManager.allReset()
    }
    
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        // 1) 컴퓨터가 랜덤 선택한 것을 이미지뷰에 표시
        // 2) 컴퓨터가 랜덤 선택한 것을 레이블에 표시
        comImageView.image = rpsManager.getComRps().rpsInfo.image
        comChoiceLabel.text = rpsManager.getComRps().rpsInfo.name

        
        // 3) 내가 선택한 것을 이미지뷰에 표시
        // 4) 내가 선택한 것을 레이블에 표시
        myImageView.image = rpsManager.getUserRps().rpsInfo.image
        myChoiceLabel.text = rpsManager.getUserRps().rpsInfo.name
        
        
        // 5) 컴퓨터가 선택한 것과 내가 선택한 것을 비교해서 이겼는지/졌는지 판단/표시
        mainLabel.text = rpsManager.getRpsResult()
    }
}

