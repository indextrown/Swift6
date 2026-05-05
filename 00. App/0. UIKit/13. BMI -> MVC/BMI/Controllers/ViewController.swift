//
//  ViewController.swift
//  BMI
//
//  Created by 김동현 on 2/19/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    
    var bmiManager = BMICalculatorManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        
    }
    
    private func makeUI() {
        // UITextField는 viewController 밖에 따로 존재하고 이 2개의 UITextField는 사용자로부터 입력을 받는다
        // 이의 대리자가 viewController가 된다
        
        // 1) textField는 유저에게 입력을 받아서 viewController에게 전달해준다
        // 2) textField내부에 delegate속성이있는데 이를 설정해줘야 대리자가 된다
        heightTextField.delegate = self
        weightTextField.delegate  = self
        
        mainLabel.text = "키와 몸무게를 입력해 주세요"
        
        // 버튼 둥글게
        calculateButton.clipsToBounds = true
        calculateButton.layer.cornerRadius = 5

        calculateButton.setTitle("BMI 계산하기", for: .normal)
        
        // placeHolder
        heightTextField.placeholder = "cm단위로 입력해주세요"
        weightTextField.placeholder = "kg단위로 입력해주세요"
        
    }

    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        
        // guard let height = heightTextField.text,
        //       let weight = weightTextField.text else { return }
        
        // bmiManager.calculateBMI(height: height, weight: weight)
    }
}

// 텍스트필드 델리게이트(디테일하게 텍스트필드 컨트롤하기이해)
extension ViewController: UITextFieldDelegate {
    // 한글자 한글자 입력될 때마다 호출되는 delegate 패천 메서드
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 선택사항..
        // if textField == heightTextField {}
        
        // 숫자로 변환이 되거나 or 빈문자열이라면 글자 입력을 허용
        if Int(string) != nil || string == "" {
            return true
        }
        
        // 숫자로 변환이 안되면 입력 불가
        return false
    }
    
    // 엔터 누르면 반응하는 함수
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 두개의 텍스트필드 모두 종료(키보드 내려가기)(자세한 조건문)
        if heightTextField.text != "", weightTextField.text != "" {
            weightTextField.resignFirstResponder()
            return true
        // 두번쨰 텍스트필드로 넘어가도록(더 넓은 범위의 조건문)
        } else if heightTextField.text != "" {
            weightTextField.becomeFirstResponder()
            return true
        }
        
        // 넘어가지 않음
        return false
    }
    
    // viewController의 view에 터치가 발생하면 반응하는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        heightTextField.resignFirstResponder()
        weightTextField.resignFirstResponder()
    }
}
 
// MARK: - 버튼을 누르면 calculateButtonTapped() -> shouldPerformSegue() -> prepare() 순서로 전부 실행됨
extension ViewController {
    // 직접 세그웨이를 구현하면 자동으로 내부적인 메커니즘에 의해 불리는 메서드
    // 다음화면으로 넘어가는걸 허락할지말지 구현 로직을 넣어주자
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if heightTextField.text == "" || weightTextField.text == "" {
            mainLabel.text = "키와 몸무게를 전부 입력해야 합니다!"
            mainLabel.textColor = UIColor.red
            return false
        }
        mainLabel.text = "키와 뭄무게를 입력해 주세요"
        mainLabel.textColor = UIColor.black
        return true
    }
    
    // 데이터 전달을 위해 구현해야하는 메서드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecondVC" {
            let secondVC = segue.destination as! SecondViewController
            
            secondVC.bmi = bmiManager.getBMI(height: heightTextField.text!, weight: weightTextField.text!)
        }
        
        // 다음화면으로 가기전에 텍스트필드 비우기
        heightTextField.text = ""
        weightTextField.text = ""
    }
}
