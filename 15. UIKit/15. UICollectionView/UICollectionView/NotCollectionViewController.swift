//
//  ViewController.swift
//  UICollectionView
//
//  Created by 김동현 on 4/30/25.
//

import UIKit

final class NotCollectionViewController: UIViewController {
    
    private let colors: [UIColor] = [.black, .blue, .brown, .cyan, .systemPink]
    
    // 사각형이 그려질 좌표의 시작점 (좌상단 기준)
    private var x = 0, y = 80
    
    // 사각형의 크기: 화면 너비의 1/3 정사각형
    private lazy var size = CGSize(width: view.frame.width/3, height: view.frame.width/3)
    
    // 현재 사각형이 그려질 좌표를 반환하는 계산 속성
    var origin: CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    // 뷰가 로드되면 drawRects()를 호출하여 사각형들을 화면에 추가
    override func viewDidLoad() {
        super.viewDidLoad()
        drawRects()
    }
}

// ViewController의 기능 확장
extension NotCollectionViewController {
    
    // 사각형 5개를 화면에 그리고, 각각 색상을 지정하여 추가
    func drawRects() {
        let views: [()] = (0...4).map {
            let frame = CGRect(origin: origin, size: size) // 위치와 크기를 지정
            let rect = UIView(frame: frame)               // 해당 프레임으로 뷰 생성
            updateDrawPoint()                             // 다음 사각형 그릴 위치 계산
            rect.backgroundColor = colors[$0]             // 색상 지정
            view.addSubview(rect)                         // 뷰에 추가
        }
    }
    
    // 다음 사각형을 그릴 위치로 좌표를 이동
    func updateDrawPoint() {
        x += Int(size.width)                              // x 좌표 증가
        if x >= Int(view.frame.width) {                   // 화면 너비를 넘으면 줄 바꿈
            x = 0
            y += Int(size.width)
        }
    }
}
