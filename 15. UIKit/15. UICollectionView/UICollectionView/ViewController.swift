//
//  ViewController.swift
//  UICollectionView
//
//  Created by 김동현 on 4/30/25.
//
// https://dev-with-precious-dreams.tistory.com/208

import UIKit

let colors: [UIColor] = [.black, .blue, .brown, .cyan, .systemPink]

class ViewController: UIViewController {
    
    // 셀마다 표시할 색상 배열 정의
    private let colors: [UIColor] = [.black, .blue, .brown, .cyan, .systemPink]
    
    // 셀 재사용을 위한 identifier
    private let cellId = "ColorCell"
    
    // 컬렉션 뷰 정의: UICollectionViewFlowLayout을 기반으로 초기화
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0 // 셀 간 좌우 간격 없음
        layout.minimumLineSpacing = 0      // 셀 간 상하 간격 없음

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId) // 셀 등록
        collectionView.dataSource = self   // 데이터 소스 설정
        collectionView.delegate = self     // 델리게이트 설정
        collectionView.translatesAutoresizingMaskIntoConstraints = false // 오토레이아웃 사용 설정
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: view.frame.width / 3 * 2) // 2줄 높이
        ])
    }
}

// MARK: - "데이터를 제공하는 역할" - 컬렉션 뷰가 화면에 보여줄 셀의 개수와 내용을 담당
// 데이터 소스 메서드 구현
extension ViewController: UICollectionViewDataSource {
    
    // 표시할 셀 개수 반환 (색상 개수만큼)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return colors.count
    }

    // 각 셀의 내용 정의
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 셀을 재사용 큐에서 꺼내옴
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        // 셀의 배경색을 colors 배열의 index에 맞게 지정
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }
}

// MARK: - "사용자 상호작용(이벤트 처리)을 담당" - 사용자가 셀을 터치, 선택, 스크롤하는 등 행동했을 때 반응하는 기능을 처리
// 셀 크기 및 간격 설정을 위한 델리게이트 구현
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    // 각 셀의 크기를 지정 (정사각형 형태)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 3 // 화면 가로의 1/3
        return CGSize(width: width, height: width)
    }

    // 셀 간 수평 간격 지정 (여기선 0)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    // 셀 간 수직 간격 지정 (여기선 0)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
