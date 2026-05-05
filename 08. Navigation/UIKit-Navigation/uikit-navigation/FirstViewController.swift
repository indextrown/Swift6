//
//  ViewController.swift
//  uikit-navigation
//
//  Created by 김동현 on 3/29/25.
//

import UIKit

class FirstViewController: UIViewController {


    @IBOutlet weak var navToSecondVCBtn: UIButton!
    
    @IBOutlet weak var navToDetailVCBtn: UIButton!
    
    @IBOutlet weak var navToDetailVCBtn2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        navToSecondVCBtn.addTarget(self, action: #selector(navToSecondVC(_:)), for: .touchUpInside)
        navToDetailVCBtn.addTarget(self, action: #selector(navToDetailVC(_:)), for: .touchUpInside)
        navToDetailVCBtn2.addTarget(self, action: #selector(navToDetailVC2(_:)), for: .touchUpInside)
    }
    
    // 2. 스토리보드로 세그웨이에 identifier 설정하여 두번째 화면으로이동
    // MARK: - 간접 세그웨이
    @objc fileprivate func navToSecondVC(_ sender: UIButton) {
        // 세그웨이 실행,  sender(보내는쪽) = self(나자신)
        self.performSegue(withIdentifier: "navToSecondVC", sender: self)
    }

    // 3. 스토리보드로 세그웨이에 identifier 설정하여 Detail화면으로 이동
    // MARK: - 간접 세그웨이
    @objc fileprivate func navToDetailVC(_ sender: UIButton) {
        // 세그웨이 실행,  sender(보내는쪽) = self(나자신)
        self.performSegue(withIdentifier: "navToDetailVC", sender: self)
    }
    
    // 3. 스토리보드로 세그웨이에 identifier 설정하여 Detail화면으로 이동
    // MARK: - 간접 세그웨이
    @objc fileprivate func navToDetailVC2(_ sender: UIButton) {
        // 세그웨이 실행,  sender(보내는쪽) = self(나자신)
        self.performSegue(withIdentifier: "navToDetailVC2", sender: self)
    }
    
    // 4. 코드로 push
    // MARK: - 코드로 스토리보드 객체를 생성해서, 화면 이동
    @IBAction func onPushBtnClicked(_ sender: UIButton) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // 나 자신 viewController를 가지고 와서 push 하겠다
        // instantiateViewController는 UIViewController 타입이므로 ViewController 타입으로 형변환
        if let vc = mainStoryboard.instantiateViewController(identifier: "SecondViewController") as? SecondViewController {
            // 현재 화면이 속해있는 ViewController에 접근하여, 내가 이동 시킬화면??
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // 5. 코드로 push(이건 네비게이션방식아님) - present(새로운 화면을 '겹쳐서' 띄우는 방식)
    // MARK: - 다음화면이 코드로 작성되어있을때만 가능한 방법
    // -------------------------------------------------------
    // MARK: 3️⃣ 코드로 Modal 방식 present (Navigation과 무관한 독립적 전환)
    // -------------------------------------------------------
    @IBAction func codeNextBtnClicked(_ sender: UIButton) {
        // 인스턴스를 찍어낸다 = 메모리에 올라간다
        let vc = CodeBaseViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - 돌아오기
    @IBAction func goBackToFirstVC(unwindSegue: UIStoryboardSegue) {
        
    }
}

/*
var stepNumber: Int = 1 {
    // 프로퍼티 옵저버
    didSet {
        self.title = "스탭넘버: \(stepNumber)"
    }
}
*/
