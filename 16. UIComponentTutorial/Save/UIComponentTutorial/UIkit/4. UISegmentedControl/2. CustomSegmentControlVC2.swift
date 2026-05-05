//
//  2. .swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/3/25.
//

import UIKit

final class CustomSegmentControlVC2: UIViewController {

    /// 커스텀 세그먼트 컨트롤 (배경/구분선/선택영역 모두 투명 처리)
    private let segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["첫번째", "두번째", "세번째"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        // 미선택 상태 스타일
        segment.setTitleTextAttributes([
            .foregroundColor: UIColor.gray
        ], for: .normal)
        // 선택 상태 스타일
        segment.setTitleTextAttributes([
            .foregroundColor: UIColor.invertedSystemBackground,
            .font: UIFont.systemFont(ofSize: 15, weight: .bold)
        ], for: .selected)
        // 투명 처리
        segment.selectedSegmentTintColor = .clear
        let image = UIImage()
        segment.setBackgroundImage(image, for: .normal, barMetrics: .default)
        segment.setBackgroundImage(image, for: .selected, barMetrics: .default)
        segment.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        segment.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        return segment
    }()

    /// 세그먼트 하단 언더라인 (선택된 영역 강조)
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .invertedSystemBackground
        view.layer.cornerRadius = 0
        return view
    }()

    // UIView 3개로 전환!
    private let view1: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        return v
    }()
    private let view2: UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        return v
    }()
    private let view3: UIView = {
        let v = UIView()
        v.backgroundColor = .green
        return v
    }()
    private lazy var dataViews: [UIView] = [view1, view2, view3]

    /// 세그먼트 하단 컨텐츠 표시 컨테이너
    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    /// 현재 선택된 세그먼트 인덱스
    private var currentPage: Int = 0 {
        didSet {
            switchContent(to: currentPage) // 컨텐츠 교체
            moveUnderline(animated: true)  // 언더라인 이동 애니메이션
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(segmentedControl)
        self.view.addSubview(underlineView)
        self.view.addSubview(contentView)

        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50),

            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
        ])
        
        // 언더라인 기본 프레임 (초기)
        underlineView.frame = CGRect(x: 0, y: 0, width: 0, height: 4)

        // 세그먼트 선택 이벤트 연결
        segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        switchContent(to: 0) // 첫번째 뷰 표시
    }

    /// 뷰 레이아웃이 결정될 때마다 언더라인 위치 업데이트
    /// 뷰 컨트롤러의 view와 그 안의 모든 서브뷰들의 위치, 크기(프레임)가 최종적으로 결정된 뒤에 자동으로 호출되는 메서드
    /// 언제 실행됨?
    ///     view가 처음 화면에 나타날 때
    ///     디바이스 회전 등으로 레이아웃이 바뀔 때
    ///     setNeedsLayout(), layoutIfNeeded() 호출 후
    ///     뷰 계층에서 프레임이 변할 때 등등
    /// 무엇에 쓰는가?
    ///     서브뷰들의 프레임에 따라 동적으로 레이아웃을 조정해야 할 때
    ///     AutoLayout 또는 frame 기반 레이아웃에서 뷰의 크기가 바뀌었을 때 뭔가 UI를 맞춰줘야 할 때 사용합니다.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        moveUnderline(animated: false)
        let segFrame = segmentedControl.frame
        underlineView.frame.origin.y = segFrame.maxY - 4
        underlineView.frame.size.height = 4
    }

    /// 세그먼트 변경 이벤트 핸들러
    @objc private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
    }

    /// 현재 인덱스에 맞는 컨텐츠 뷰 표시
    private func switchContent(to index: Int) {
        // 모든 서브뷰 제거
        contentView.subviews.forEach { $0.removeFromSuperview() }
        let selectedView = dataViews[index]
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(selectedView)
        NSLayoutConstraint.activate([
            selectedView.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            selectedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    /// 언더라인을 현재 선택된 세그먼트 아래로 이동
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

#Preview {
    CustomSegmentControlVC2()
}
