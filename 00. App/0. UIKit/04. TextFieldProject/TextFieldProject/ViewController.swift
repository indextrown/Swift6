//
//  ViewController.swift
//  TextFieldProject
//
//  Created by 김동현 on 2/14/25.
//

import UIKit


/*
 프로토콜을 사용하는 이유
 - 애플 입장에서 개발자가 TV, SmartPhone, MyViewController 등 어떤 이름을 쓸 지 정해두지 않았기 때문에 프로토콜 타입으로 정의하였다. 프로토콜 자체가 타입이기 때문에 이 타입을 채택하면 어떤 이름을 쓰더라도 상관없이 사용가능하다
 - 뷰컨트롤러에게 상황에 대한 판단(동작)을 위임 가능하다
 
 텍스트필드는 델리게이트 패턴이 필요한 이유
 - 텍스트필드는 동작이 복잡하다
 - 복잡한 동작을 제대로 구현하려면 동작이 일어나는 행동은 텍스트필드에서 일어나고 결과를 뷰컨트롤러에 전달하면서 시점파악, 뷰컨트롤러에게 허락을 물어보는 역할
 - 즉 복잡한 동작을 구현하기 위해 델리게이트 패턴(프로토콜 = textField)을 사용한다, 뷰컨트롤러는 프로토콜을 채택해야한다
 -
 */

// 자격증에는 반드시 구현해야되는 필수 요구사항 존재.. 빨간줄안뜨면 선택적 요구사항으로 메서드가 정의됨..
class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textField: 인스턴스 객체
        // 텍스트필드의 delegate(대리자)를 viewController로 설정하겠다
        textField.delegate = self
        
        // UI
        setUp()
    }
    
    func setUp() {
        // view는 UIViewController 즉 상위클래서에 정의되있다.
        // ViewController에는 가장 하위에 기본적인 view가 하나 깔려있다.
        view.backgroundColor = UIColor.gray
        
        // 텍스트필드 키보드 스타일
        textField.keyboardType = UIKeyboardType.emailAddress
        
        // 텍스트필드 기본 문구
        textField.placeholder = "이메일 입력"
        
        // 텍스트필드 선 스타일
        textField.borderStyle = .roundedRect
        
        // x모양 클리어버튼 보이도록
        textField.clearButtonMode = .always
        
        // 엔터형태 지정 가능
        textField.returnKeyType = .go
        
        // MARK: - 화면이 보여질때 자동으로 키보드가 뜨도록 하는법 (앱의 화면에 들어오자마자 처음으로 응답하는 설정)
        textField.becomeFirstResponder()
    }
    
    
    // 텍스트 필드의 입력을 시작할때 호출 (시작할지 말지의 여부 허락하는 것) (자격증에는 선택사항)
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }
    
    // 참과 거짓을 리턴하지 않는 메서드들은 대부분 시점을 의미
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#function)
        print("유저가 텍스트필드의 입력을 시작했다. ")
    }
    
    // 텍스트필드 정리를 허락할지 말지
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }
    
    // 텍스트필드 글자 내용이 (한글자 한글자) 입력되거나 지워질 때 호출되고.. 입력이될지 허락 여부도 가능
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // How to limit the number of characters in a text field to 10 characters
        
        // MARK: - TIP: 구현방법을 너무 자세하게 보지말고 복붙하여 사용하자
        /*
         1)
        let maxLength = 10
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        return newString.count <= maxLength
         */
        
        
        // 입력되고 있는 글자가 숫자인 경우 입력 허용하지 않는 코드
        if Int(string) != nil {
            return false
        } else {
            // 10글자 이상 입력 막는 코드
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 10
        }
        
        // 10글자이상 입력 막는 코드
        /*
        if (textField.text?.count)! + string.count > 10 {
            return false
        } else {
            return true
        }
         */
    }
    
    // 텍스트필드의 엔터키가 눌러지면 다음 동작을 허락할것인지 말것인지
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#function)
        
        if textField.text == "" {
            textField.placeholder = "Type Something!"
            return false
        } else {
            return true
        }
    }
    
    // 텍스트필드의 입력이 끝날 때 호출(끝날지 말지를 허락)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }
    
    // 텍스트필드 입력이 끝났을 때 호출(시점)
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(#function)
        print("유저가 텍스트필드의 입력을 끝냈다. ")
    }

    // done누르면 키보드 내려감
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        textField.resignFirstResponder()
    }
    
    // 화면의 탭을 감지하는 메서드
    // 화면을 터치했을 때 키보드를 어떻게 내리는지
    // How to lower the keyboard when touching the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)       // 뷰 전체를 끝내기
        // textField.resignFirstResponder() // 텍스트필드 하나만 끝내기
    }
    
}

