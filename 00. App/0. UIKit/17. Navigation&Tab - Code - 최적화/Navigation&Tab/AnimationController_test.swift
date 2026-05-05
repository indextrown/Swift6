//
//  AnimationController_test.swift
//  Navigation&Tab
//
//  Created by 김동현 on 2/27/25.
//

import UIKit

final class AnimationViewController: UIViewController {
    
    // 전환 대리자를 strong하게 참조하기 위한 프로퍼티
    private var customTransitionDelegate: CustomTransitionDelegate?
    
    // 로그인 버튼
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .blue
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    func makeUI() {
        // view에 버튼 올리기
        view.addSubview(nextButton)
        
        // 오토 레이아웃ㄷ
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 120),
            nextButton.heightAnchor.constraint(equalToConstant: 45),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func nextButtonTapped() {
        // 탭바컨트롤러 생성
        let tabBarVC = UITabBarController()
        
        // 첫 화면은 네비게이션 컨트롤러로 만들자(기본루트뷰 설정)
        let vc1 = UINavigationController(rootViewController: FirstViewController())
        let vc2 = SecondViewController()
        let vc3 = ThirdViewController()
        let vc4 = FourthViewController()
        let vc5 = FifthViewController()
        
        // 탭바 이름들 설정
        vc1.title = "Main"
        vc2.title = "Search"
        vc3.title = "Post"
        vc4.title = "Likes"
        vc5.title = "Me"
        
        // 탭바로 사용하기 위한 뷰 컨트롤러들 설정
        tabBarVC.setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.backgroundColor = .white
        
        // 탭바 이미지 설정
        guard let items = tabBarVC.tabBar.items else { return }
        
        items[0].image = UIImage(systemName: "square.and.arrow.up")
        items[1].image = UIImage(systemName: "folder")
        items[2].image = UIImage(systemName: "paperplane")
        items[3].image = UIImage(systemName: "doc")
        items[4].image = UIImage(systemName: "note")
        
        // 커스텀 전환 애니메이션 설정
                let customDelegate = CustomTransitionDelegate()
                tabBarVC.transitioningDelegate = customDelegate
                tabBarVC.modalPresentationStyle = .custom
        
        // 프리젠트로 탭바 띄우기
        present(tabBarVC, animated: true, completion: nil)
        

    }
}




class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    // 애니메이션 지속 시간
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    // 애니메이션 구현
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
              let fromVC = transitionContext.viewController(forKey: .from) else { return }
        
        let container = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        // 시작 위치를 화면 오른쪽 밖으로 설정
        toVC.view.frame = finalFrame.offsetBy(dx: finalFrame.width, dy: 0)
        container.addSubview(toVC.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            // toVC가 오른쪽에서 왼쪽으로 이동
            toVC.view.frame = finalFrame
            // 선택사항: fromVC도 살짝 왼쪽으로 이동시켜 자연스러운 효과를 줄 수 있음
            fromVC.view.frame = fromVC.view.frame.offsetBy(dx: -finalFrame.width * 0.3, dy: 0)
        }) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}



class CustomTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    // 프리젠트할 때 사용할 애니메이터 반환
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPushAnimator()
    }
    
    // Dismiss 시 역방향 애니메이션을 구현하고 싶다면 여기도 구현 (현재는 기본 애니메이션 사용)
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
