//
//  4. .swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/3/25.
//


/*
 
import UIKit

final class CustomSegmentedControl: UISegmentedControl {

    // 언더라인 뷰
    private let underlineView = UIView()
    private var underlineLeadingConstraint: NSLayoutConstraint!
    private var underlineWidthConstraint: NSLayoutConstraint!
    private let underlineHeight: CGFloat = 4.0

    // 생성자
    override init(items: [Any]?) {
        super.init(items: items)
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        // 기본 스타일 (원하는 대로 조정)
        setTitleTextAttributes([
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 16)
        ], for: .selected)
        setTitleTextAttributes([
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 16)
        ], for: .normal)
        
        selectedSegmentTintColor = .clear
        

        // 언더라인 추가
        underlineView.backgroundColor = .systemBlue
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underlineView)
        sendSubviewToBack(underlineView)

        // 오토레이아웃
        underlineLeadingConstraint = underlineView.leadingAnchor.constraint(equalTo: leadingAnchor)
        underlineWidthConstraint = underlineView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0 / CGFloat(numberOfSegments))
        NSLayoutConstraint.activate([
            underlineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: underlineHeight),
            underlineLeadingConstraint,
            underlineWidthConstraint
        ])

        // 값 변경 이벤트
        addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }

    // 언더라인 이동
    @objc private func segmentChanged() {
        moveUnderline(animated: true)
    }

    // 외부에서 강제 이동 필요시 호출
    func moveUnderline(animated: Bool) {
        layoutIfNeeded()
        let count = CGFloat(numberOfSegments)
        let segmentWidth = frame.width / max(count, 1)
        underlineLeadingConstraint.constant = segmentWidth * CGFloat(selectedSegmentIndex)
        if animated {
            UIView.animate(withDuration: 0.2) { self.layoutIfNeeded() }
        } else {
            self.layoutIfNeeded()
        }
    }

    // 사이즈 변경 시에도 언더라인 이동
    override func layoutSubviews() {
        super.layoutSubviews()
        moveUnderline(animated: false)
    }

}


final class CustomSegmentControlVC4: UIViewController {

    private let segmentedControl: CustomSegmentedControl = {
        let segment = CustomSegmentedControl(items: ["첫번째", "두번째"])
        return segment
    }()

    private let vc1: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        return vc
    }()
    private let vc2: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        return vc
    }()
    private let vc3: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .green
        return vc
    }()
    
    var dataViewControllers: [UIViewController] { [vc1, vc2] }

    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        vc.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        vc.delegate = self
        vc.dataSource = self
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()

    var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers(
                [dataViewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLogoTitle()
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.pageViewController.view)

        NSLayoutConstraint.activate([
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])

        // 언더라인의 높이와 최초 위치 설정 (width, x는 viewDidLayoutSubviews에서)
       //  underlineView.frame = CGRect(x: 0, y: 0, width: 0, height: 4)

        segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        changeValue(control: segmentedControl)
    }
    
    private func setupLogoTitle() {
        /// 네비게이션 버튼 색상
        self.navigationController?.navigationBar.tintColor = .white
        
        /// 네비게이션 제목
        segmentedControl.sizeToFit() // 글자 길이에 맞게 label 크기 조정
        self.navigationItem.titleView = segmentedControl
        
        /// 좌측 네비게이션 버튼
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "calendar"),
            style: .plain,
            target: self,
            action: nil
        )
        
        /// 우측 네비게이션 버튼
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.fill"),
            style: .plain,
            target: self,
            action: nil
        )
        
        /// 자식 화면에서 뒤로가기
        let backItem = UIBarButtonItem()
        backItem.title = "홈으로"
        navigationItem.backBarButtonItem = backItem
    }



    @objc private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
    }
}

extension CustomSegmentControlVC4: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.dataViewControllers.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        return self.dataViewControllers[index - 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.dataViewControllers.firstIndex(of: viewController), index + 1 < self.dataViewControllers.count else { return nil }
        return self.dataViewControllers[index + 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?[0], let index = self.dataViewControllers.firstIndex(of: viewController) else { return }
        self.currentPage = index
        self.segmentedControl.selectedSegmentIndex = index
    }
}

#Preview {
//    CustomSegmentControlVC4()
     UINavigationController(rootViewController: CustomSegmentControlVC4())
}
*/

import UIKit

final class CustomSegmentedBarView: UIView {
    let segmentedControl: UISegmentedControl
    private let underlineView = UIView()
    private var underlineLeadingConstraint: NSLayoutConstraint!
    private var underlineWidthConstraint: NSLayoutConstraint!
    private let underlineHeight: CGFloat = 4.0

    init(items: [String]) {
        self.segmentedControl = UISegmentedControl(items: items)
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        
        let image = UIImage()
        segmentedControl.setBackgroundImage(image, for: .normal, barMetrics: .default)
        segmentedControl.setBackgroundImage(image, for: .selected, barMetrics: .default)
        segmentedControl.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        segmentedControl.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        
        // 스타일
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = .systemBlue

        addSubview(segmentedControl)
        addSubview(underlineView)

        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 32),

            underlineView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: underlineHeight),
            underlineView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        // 동적 width/leading
        underlineLeadingConstraint = underlineView.leadingAnchor.constraint(equalTo: leadingAnchor)
        underlineWidthConstraint = underlineView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0 / CGFloat(segmentedControl.numberOfSegments))
        NSLayoutConstraint.activate([underlineLeadingConstraint, underlineWidthConstraint])

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }

    @objc private func segmentChanged() {
        moveUnderline(animated: true)
    }

    func moveUnderline(animated: Bool) {
        layoutIfNeeded()
        let count = CGFloat(segmentedControl.numberOfSegments)
        let segmentWidth = bounds.width / max(count, 1)
        underlineLeadingConstraint.constant = segmentWidth * CGFloat(segmentedControl.selectedSegmentIndex)
        if animated {
            UIView.animate(withDuration: 0.2) { self.layoutIfNeeded() }
        } else {
            self.layoutIfNeeded()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        moveUnderline(animated: false)
    }
}



// 2. 뷰컨트롤러
final class CustomSegmentControlVC4: UIViewController {

    private let segmentedBar = CustomSegmentedBarView(items: ["첫번째", "두번째"])

    private let vc1: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        return vc
    }()
    private let vc2: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        return vc
    }()

    var dataViewControllers: [UIViewController] { [vc1, vc2] }

    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        vc.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        vc.delegate = self
        vc.dataSource = self
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()

    var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers(
                [dataViewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLogoTitle()
    }

    private func setupUI() {
        view.backgroundColor = .white

        segmentedBar.translatesAutoresizingMaskIntoConstraints = false
        // view.addSubview(segmentedBar)
        view.addSubview(pageViewController.view)

        NSLayoutConstraint.activate([
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        segmentedBar.segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        segmentedBar.segmentedControl.selectedSegmentIndex = 0
        changeValue(control: segmentedBar.segmentedControl)
    }

    private func setupLogoTitle() {
        self.navigationController?.navigationBar.tintColor = .white
        // 네비바 타이틀로 쓰고 싶으면 아래처럼 사용
        // segmentedBar.frame = CGRect(x: 0, y: 0, width: 220, height: 36)
        self.navigationItem.titleView = segmentedBar

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "calendar"),
            style: .plain,
            target: self,
            action: nil
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.fill"),
            style: .plain,
            target: self,
            action: nil
        )
        let backItem = UIBarButtonItem()
        backItem.title = "홈으로"
        navigationItem.backBarButtonItem = backItem
    }

    @objc private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
        segmentedBar.moveUnderline(animated: true)
    }
}

extension CustomSegmentControlVC4: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.dataViewControllers.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        return self.dataViewControllers[index - 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.dataViewControllers.firstIndex(of: viewController), index + 1 < self.dataViewControllers.count else { return nil }
        return self.dataViewControllers[index + 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?[0], let index = self.dataViewControllers.firstIndex(of: viewController) else { return }
        self.currentPage = index
        segmentedBar.segmentedControl.selectedSegmentIndex = index
        segmentedBar.moveUnderline(animated: true)
    }
}

#Preview {
    UINavigationController(rootViewController: CustomSegmentControlVC4())
}
