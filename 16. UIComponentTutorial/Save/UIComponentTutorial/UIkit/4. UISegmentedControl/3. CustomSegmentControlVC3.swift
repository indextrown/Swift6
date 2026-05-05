//
//  3. .swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/3/25.
//

import UIKit

final class SegmentedContainerViewController: UIViewController {

    // MARK: - Properties
    private let segmentTitles: [String]
    private let viewControllers: [UIViewController]

    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: segmentTitles)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        // 스타일 커스텀 (필요 시 수정)
        segment.setTitleTextAttributes([
            .foregroundColor: UIColor.gray
        ], for: .normal)
        segment.setTitleTextAttributes([
            .foregroundColor: UIColor.invertedSystemBackground,
            .font: UIFont.systemFont(ofSize: 15, weight: .bold)
        ], for: .selected)
        segment.selectedSegmentTintColor = .clear
        let image = UIImage()
        segment.setBackgroundImage(image, for: .normal, barMetrics: .default)
        segment.setBackgroundImage(image, for: .selected, barMetrics: .default)
        segment.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        segment.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        segment.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        return segment
    }()

    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .invertedSystemBackground
        view.layer.cornerRadius = 0
        return view
    }()

    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        vc.delegate = self
        vc.dataSource = self
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()

    private var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers(
                [viewControllers[currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
            moveUnderline(animated: true)
        }
    }

    // MARK: - Initializer
    init(titles: [String], viewControllers: [UIViewController]) {
        self.segmentTitles = titles
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(segmentedControl)
        view.addSubview(underlineView)
        view.addSubview(pageViewController.view)

        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50),

            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
        ])

        // 언더라인 최초 위치 (width/x는 viewDidLayoutSubviews에서)
        underlineView.frame = CGRect(x: 0, y: 0, width: 0, height: 4)

        // 최초 VC 셋팅
        pageViewController.setViewControllers(
            [viewControllers[0]], direction: .forward, animated: false, completion: nil
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        moveUnderline(animated: false)
        let segFrame = segmentedControl.frame
        underlineView.frame.origin.y = segFrame.maxY - 4
        underlineView.frame.size.height = 4
    }

    // MARK: - Actions
    @objc private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
    }

    private func moveUnderline(animated: Bool) {
        let segFrame = segmentedControl.frame
        let segmentCount = CGFloat(segmentedControl.numberOfSegments)
        let segmentWidth = segFrame.width / segmentCount
        let targetX = segFrame.minX + segmentWidth * CGFloat(segmentedControl.selectedSegmentIndex)

        let newFrame = CGRect(x: targetX,
                              y: segFrame.maxY - 4,
                              width: segmentWidth,
                              height: 4)
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.underlineView.frame = newFrame
            }
        } else {
            self.underlineView.frame = newFrame
        }
    }
}

// MARK: - UIPageViewControllerDataSource, Delegate
extension SegmentedContainerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.viewControllers.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        return self.viewControllers[index - 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.viewControllers.firstIndex(of: viewController), index + 1 < self.viewControllers.count else { return nil }
        return self.viewControllers[index + 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.first,
              let index = self.viewControllers.firstIndex(of: viewController) else { return }
        self.currentPage = index
        self.segmentedControl.selectedSegmentIndex = index
        self.moveUnderline(animated: true)
    }
}

final class FirstContentViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        let label = UILabel()
        label.text = "첫 번째 탭"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

final class SecondContentViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        let label = UILabel()
        label.text = "두 번째 탭"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

final class ThirdContentViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        let label = UILabel()
        label.text = "세 번째 탭"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

let firstVC = FirstContentViewController()
let secondVC = SecondContentViewController()
let thirdVC = ThirdContentViewController()

let segmentTitles = ["첫번째", "두번째"]

let segmentedVC = SegmentedContainerViewController(
    titles: segmentTitles,
    viewControllers: [firstVC, secondVC]
)

#Preview {
    SegmentedContainerViewController(
        titles: segmentTitles,
        viewControllers: [firstVC, secondVC])
}
