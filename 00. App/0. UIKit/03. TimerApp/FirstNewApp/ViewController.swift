//
//  ViewController.swift
//  FirstNewApp
//
//  Created by 김동현 on 2/13/25.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // MARK: - 가리키는 상대방의reference counting을 올라가지 않는게 weak
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var slider: UISlider!    // slider.value // 0.0 ~ 1.0
    
    // MARK: - 타이머는 Class로구현됨. 클래스인스턴스는 heap에 저장되므로 weak으러 선언(서로를 가리킬 수 있는 가능성 없애기)
    weak var timer: Timer?
    var number: Int = 0
    
    // MARK: - 상위의 UIViewController에 정의된 viewDidLoad()함수 재정의
    // 앱이 화면에 들어오면 처음 실행
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // how to change the value of uislider in swift
    func configureUI() {
    
        mainLabel.text = "초를 선택하세요"
        
        // 슬라이더의 가운데 설정
        slider.value = 0.5
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        // slider.value // 0.0 ~ 1.0 이므로
        number = Int(sender.value * 60)
        
        // 슬라이다 value값을 가지고 메인레이블의 텍스트를 세팅
        mainLabel.text = "\(number)초"
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        mainLabel.text = "초를 선택하세요"
        // 슬라이더의 가운데 설정(with animation)
        slider.setValue(0.5, animated: true)
        number = 0
        timer = nil
    }
    
    // how to run a function after some time in swift
    // how to execute a function every second in swift
    // how can i make function every second in swift
    // do something every x minutes in swift
    // https://stackoverflow.com/questions/25951980/do-something-every-x-minutes-in-swift
    // how to play system sound in swift
    @IBAction func startButtonTapped(_ sender: UIButton) {
        // 1초씩 지나갈때마다 무언가를 실행
        
        timer?.invalidate()   // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
        
        
        /* 1번 방식
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] _ in
            // 반복을 하고 싶은 코드
            
            if number > 0 {
                // 1) 1초씩 감소
                number -= 1
                
                // 2) 슬라이더 줄이기
                slider.value = Float(number) / Float(60)
                
                // 3) label도 다시 표시
                mainLabel.text = "\(number) 초"
                
            } else {
                number = 0
                mainLabel.text = "초를 선택하세요"
                
                // 타이머 비활성화
                timer?.invalidate()
                
                // 소리를 나게 해야됨
                AudioServicesPlayAlertSound(SystemSoundID(1322))
            }
        }
         */
        
        // 2번방식
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(doSomethingAfter1Second), userInfo: nil, repeats: true)
    }
    
    // 2번방식
    // #selector는 메모리 주소를 담아서 어떤 함수를 가리키는지 연결 시키는건데 object-c에서 사용하던 방식이라 @objc 해준다
    @objc func doSomethingAfter1Second() {
        if number > 0 {
            // 1) 1초씩 감소
            number -= 1
            
            // 2) 슬라이더 줄이기
            slider.value = Float(number) / Float(60)
            
            // 3) label도 다시 표시
            mainLabel.text = "\(number) 초"
            
        } else {
            number = 0
            mainLabel.text = "초를 선택하세요"
            
            // 타이머 비활성화
            timer?.invalidate()
            
            // 소리를 나게 해야됨
            AudioServicesPlayAlertSound(SystemSoundID(1322))
        }
    }
}

