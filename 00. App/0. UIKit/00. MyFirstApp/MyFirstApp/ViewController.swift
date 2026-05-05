//
//  ViewController.swift
//  MyFirstApp
//
//  Created by 김동현 on 2/12/25.
//

import UIKit

// MARK: - @IBOutlet 변수 또는 @IBAction이 붙은 함수는 private을 사용하지 않는 것이 좋다
// MARK: - 스토리보드에서 호출되려면 internal(기본 접근 수준)이어야 한다
// MARK: - 좌측의 인터페이스 빌더는 코드를 편리하게 보여주는것이다 코드로 작성하는 것이 우선순위

final class ViewController: UIViewController {
    
    // 변수 - 속성 변경
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var myButton: UIButton!
    
    // 앱이 화면에 들어오면 처음 실행시키는 함수
    override func viewDidLoad() {
        super.viewDidLoad()
        mainLabel.text = "초기 글자"
        myButton.backgroundColor = UIColor.black
        myButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
    }

    // 함수(파라미터 이름을 관습적으로 sender 라고 한다. 보내는 녀석)
    @IBAction func buttonPressed(_ sender: UIButton) {
        mainLabel.text = "안녕하세요"
        mainLabel.textColor = UIColor.white
        mainLabel.backgroundColor = UIColor.black
        
        // 컬러 리터럴 기능(색상 클릭하여 설정 가능 기능) #colorLiteral( 타이핑
        mainLabel.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        // NSTextAlignment는 애플이 미리 정해둔 열거형 타입
        mainLabel.textAlignment = NSTextAlignment.right
    }
}
