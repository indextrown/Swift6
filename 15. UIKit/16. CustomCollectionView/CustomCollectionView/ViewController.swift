//
//  ViewController.swift
//  CustomCollectionView
//
//  Created by 김동현 on 4/30/25.
//
// https://velog.io/@jyw3927/Swift-Custom-Cell로-UICollectionView-구현하기-i4xtxih4
// https://medium.com/better-programming/the-swiftui-equivalents-to-uicollectionview-60415e3c1bbe

import UIKit

// MARK: - 카드 모델 정의
struct Card {
    let nickname: String
    let image: String
}

extension Card {
    static var sampleData = [
        Card(nickname: "cat1", image: "cat1"),
        Card(nickname: "dog1", image: "dog1"),
        Card(nickname: "dog1", image: "dog1"),
        Card(nickname: "dog1", image: "dog1"),
    ]
}

// MARK: - UICollectionViewCell 커스텀 셀 정의
final class CardCell: UICollectionViewCell {
    static let identifier = "CardCell" // 셀 재사용을 위한 식별자
    
    // 이미지 뷰: 셀의 배경 이미지를 보여줌
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill           // 셀 채우되 비율 유지
        iv.clipsToBounds = true                     // 셀 밖 이미지 자르기
        iv.layer.cornerRadius = 15                  // 모서리 둥글게
        return iv
    }()
    
    // 타이틀 라벨: 이미지 위에 카드 이름 보여줌
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.3) // 반투명 배경
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    // 셀 생성자: 이미지 뷰와 라벨을 셀에 추가
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
        contentView.addSubview(titleLabel)
    }
    
    // 스토리보드 사용 시 필수 이니셜라이저
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 셀 내부 요소 배치 (레이아웃)
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        titleLabel.frame = CGRect(x: 0,
                                  y: contentView.bounds.height - 30, // 아래쪽에 고정
                                  width: contentView.bounds.width,
                                  height: 30)
    }
    
    // 외부에서 데이터를 받아 셀 구성
    func configure(with card: Card) {
            imageView.image = UIImage(named: card.image)
            titleLabel.text = card.nickname
        }
}

final class ViewController: UIViewController {
    
    // 카드 데이터 배열
    private var cards = Card.sampleData
    
    // 컬렉션 뷰 정의 (FlowLayout 사용)
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12   // 열 간격
        layout.minimumLineSpacing = 16        // 행 간격
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.systemTeal
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // UI 구성 함수
    private func setupUI() {
        view.backgroundColor = .systemTeal
        view.addSubview(collectionView)
    }
    
    // 오토 레이아웃 제약 설정
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource (데이터 제공 역할)
extension ViewController: UICollectionViewDataSource {
    // 셀 개수 반환
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    // 셀 설정
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as? CardCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: cards[indexPath.item]) // 셀에 데이터 적용
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout (셀 사이즈 및 레이아웃 조정)
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView_3(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacing: CGFloat = 12
        let totalSpacing = spacing * 2         // 아이템 사이 간격 2개 (3개 = 2칸)
        let horizontalInset: CGFloat = 16 * 2  // leading + trailing

        let availableWidth = view.frame.width - totalSpacing - horizontalInset
        let itemWidth = floor(availableWidth / 3)

        return CGSize(width: itemWidth, height: itemWidth * 1.2)
    }

    // 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 12
        let width = (view.frame.width - 16 * 2 - spacing) / 2
        return CGSize(width: width, height: width * 1.2)
    }
}
