//
//  ViewController.swift
//  CombineTutorial-example
//
//  Created by 김동현 on 7/14/25.
//

import UIKit
import Combine
import CombineCocoa

enum ExampleType: Int, CaseIterable {
    case numbersUIKit    // rawValue: 0
    case numbersSwiftUI  // 1
    case validationUIKit // 2
    
    func makeButton() -> UIButton {
        let button = UIButton(type: .system)
        button.configuration = .filled()
        button.setTitle(String(describing: self), for: .normal)
        button.tag = self.rawValue
        return button
    }
    
    func makeVC() -> UIViewController {
        switch self {
        case .numbersUIKit:
            NumbersViewController.instantiate("Numbers")
        case .numbersSwiftUI:
            NumbersView().getContainerVC()
        case .validationUIKit:
            ValidationExampleViewController.instantiateFromNib()
        }
    }
}

class ViewController: UIViewController {

    // Combine의 구독을 저장하는 Set
    // VC가 해제되면 subscriptions 프로퍼티도 함께 메모리에서 해제되고, 그 안에 저장된 구독들도 함께 해제되어 메모리 누수를 방지한다
    // 구독 찌꺼기 담는 통: VC가 메모리에서 해제되면 VC에서 사용된 구독 찌꺼기가 담긴다
    var subscriptions = Set<AnyCancellable>()
    
    @IBOutlet weak var buttonContainerStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let exampleTypes: [ExampleType] = ExampleType.allCases
        
        exampleTypes.forEach { aType in
            let button = aType.makeButton()
            button
                .tapPublisher
                .sink(receiveValue: { [weak self] in // 클로저 내에서 self를 사용하니까 강한참조를 뺴기 위해 캡처리스트로 약하게 해준다
                    // 각 타입마다 뷰컨트롤러 종류가 다르다(storyboard, swiftUI, xib)
                    guard let self = self else { return }
                    let vc = aType.makeVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                })
                .store(in: &subscriptions)
            
            buttonContainerStackView.addArrangedSubview(button)
        }
    }
}
