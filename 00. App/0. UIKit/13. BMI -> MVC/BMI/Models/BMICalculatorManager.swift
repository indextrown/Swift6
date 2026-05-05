//
//  BMICalculatorManager.swift
//  BMI
//
//  Created by 김동현 on 2/19/25.
//

import UIKit

// MARK: - 큰프로젝트시 heap에 저장되는게 좋다 즉 class로 만드는게 좋다(mutating제거)..
// 이유: 여러 viewController에서 이 비지니스 로직에 접근하기 좋기 때문
// 이 프로젝트에서는 하나의 viewController에서만 이 비지니스 로직에 접근하기 때문에 구조체 사용하였음

// BMI 계산하는 매니저
struct BMICalculatorManager {
    
    // BMI 계산 결과값보관을위한 변수
    var bmi: BMI?
    
    // BMI 만들기 메서드
    mutating func getBMI(height: String, weight: String) -> BMI {
        calculateBMI(height: height, weight: weight)
        return bmi ?? BMI(value: 0.0, advice: "문제발생", matchColor: UIColor.white)
    }
    
    // BMI 만들기 메서드(BMI수치 계산해서 BMI 구조체 인스턴스 만드는 메서드)
    mutating func calculateBMI(height: String, weight: String) {
        guard let h = Double(height), let w = Double(weight) else {
            bmi = BMI(value: 0.0, advice: "문제발생", matchColor: UIColor.white)
            return
        }
        
        var bmiNum = w / (h * h) * 10000
        bmiNum = round(bmiNum * 10) / 10 // 반올림
        
        switch bmiNum {
        case ..<18.6:
            let color = UIColor(displayP3Red: 22/255, green: 231/255, blue: 207/255, alpha: 1)
            bmi = BMI(value: bmiNum, advice: "저체중", matchColor: color)
        case 18.6..<23.0:
            let color = UIColor(displayP3Red: 212/255, green: 251/255, blue: 121/255, alpha: 1)
            bmi = BMI(value: bmiNum, advice: "표준", matchColor: color)
        case 23.0..<25.0:
            let color = UIColor(displayP3Red: 218/255, green: 127/255, blue: 163/255, alpha: 1)
            bmi = BMI(value: bmiNum, advice: "과체중", matchColor: color)
        case 25.0..<30.0:
            let color = UIColor(displayP3Red: 255/255, green: 150/255, blue: 141/255, alpha: 1)
            bmi = BMI(value: bmiNum, advice: "중도비만", matchColor: color)
        case 30.0...:
            let color = UIColor(displayP3Red: 255/255, green: 100/255, blue: 78/255, alpha: 1)
            bmi = BMI(value: bmiNum, advice: "고도비만", matchColor: color)
        default:
            bmi = BMI(value: bmiNum, advice: "문제발생", matchColor: UIColor.white)
        }
    }
    
    
    
    
//    // BMI 계산 메서드
//    // MARK: - 구조체 속성을 함수 내부에서 변경시 mutating 키워드 필요
//    mutating func calculateBMI(height: String, weight: String) {
//        guard let h = Double(height), let w = Double(weight) else {
//            bmi = 0.0
//            return
//        }
//        let bmiNumber = w / (h * h) * 10000
//        // print("반올림 전\(bmi)")
//        bmi = round(bmiNumber * 10) / 10 // 반올림
//        // print("BMI 결과값: \(bmi)")
//    }
//    
//    // BMI 계산 결과값 반환
//    func getBMIResult() -> BMI {
//        return bmi ?? BMI(value: 0.0, matchColor: UIColor.white, advice: "문제발생")// 생성자
//    }
//    
//    // 배경색 얻는 메서드
//    func getBackgroundColor() -> UIColor {
//        guard let bmi = bmi else { return UIColor.black }
//        switch bmi {
//        case ..<18.6:
//            return UIColor(displayP3Red: 22/255, green: 231/255, blue: 207/255, alpha: 1)
//        case 18.6..<23.0:
//            return UIColor(displayP3Red: 212/255, green: 251/255, blue: 121/255, alpha: 1)
//        case 23.0..<25.0:
//            return UIColor(displayP3Red: 218/255, green: 127/255, blue: 163/255, alpha: 1)
//        case 25.0..<30.0:
//            return UIColor(displayP3Red: 255/255, green: 150/255, blue: 141/255, alpha: 1)
//        case 30.0...:
//            return UIColor(displayP3Red: 255/255, green: 100/255, blue: 78/255, alpha: 1)
//        default:
//            return UIColor.black
//        }
//    }
//    
//    // bmi 값에 따라 문자열 얻는 메서드
//    func getBMIAdviceString() -> String {
//        guard let bmi = bmi else { return "" }
//        switch bmi {
//        case ..<18.6:
//            return "저체중"
//        case 18.6..<23.0:
//            return "표준"
//        case 23.0..<25.0:
//            return "과체중"
//        case 25.0..<30.0:
//            return "중도비만"
//        case 30.0...:
//            return "고도비만"
//        default:
//            return ""
//        }
//    }
}
