//  ScrollViewController.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/5/25.
//

import UIKit
import Kingfisher

/*
 좌우 패딩 20
 - sectionInset.left = 20
 - sectionInset.right = 20
 
 이미지셀 크기
 - 패딩 빼고 남은 공간에 딱 한 장만 보이게
 - 셀 width = 전체 width - 좌우 패딩 합
 - 셀 width = 390 - 20 - 20 = 350
 
 셀과 셀 사이 간격(minimumLineSpacing)
 - 페이징은 "한 화면 = 390pt" 단위로 움직임
 - 만약 셀과 셀 사이 간격이 0이면:
 - 두 번째 이미지는 370~720 위치에 있음
 - 스크롤하면 350씩 이동하지만, 화면 기준(390)과 안 맞아서
 "두 장이 한 번에 보이거나", "한 장이 정확히 중앙에 안 옴"
 
 해결법
 - 셀 사이 간격 = (전체 화면 - 셀 width)
 - 즉, minimumLineSpacing = 390 - 350 = 40
 
 정리
 - 셀 width = collectionView.bounds.width - (sectionInset.left + sectionInset.right)
 - minimumLineSpacing = sectionInset.left + sectionInset.right
 
 
 */
final class ScrollViewController: UIViewController {
    
    private let imageUrls: [String] = [
        "https://upload.wikimedia.org/wikipedia/en/5/5f/Original_Doge_meme.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Gatto_europeo4.jpg/500px-Gatto_europeo4.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Gatto_europeo4.jpg/500px-Gatto_europeo4.jpg"
    ]
    
    // MARK: - UI Component
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 40
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("닫기", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return btn
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        makeUI()
        constraints()
    }
    
    // MARK: - UI Setting
    private func makeUI() {
        view.backgroundColor = .black
        
        [collectionView, closeButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            // 위치
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // 크기
            closeButton.widthAnchor.constraint(equalToConstant: 60),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc func closeTapped() {
        dismiss(animated: true)
    }
    
}

extension ScrollViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.setKFImage(url: imageUrls[indexPath.item])
        return cell
    }
    
    // 셀의 크기를 컬렉션뷰와 동일하게
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
     */
    // 셀의 크기를 컬렉션뷰와 동일하게
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 40 // 좌우 20 여백
        return CGSize(width: width, height: width)
    }
}

#Preview {
    ScrollViewController()
}


final class ImageCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()
    
    /// UIView(그리고 UICollectionViewCell, UITableViewCell 등) 생성자(Initializer) 중 하나
    /// UIKit의 거의 모든 View, Cell, Layout은 “프로그래밍으로” 만들 때 init(frame: CGRect)라는 생성자를 사용
    /// frame
    /// “이 View가 superview(상위 뷰)에서 어느 위치, 어느 크기로 들어갈지”를 의미
    /// 보통 코드로 View를 만들 때 직접 frame을 넘겨주거나, 오토레이아웃을 쓰면 frame: .zero로 두고, 제약조건(Constraints)으로 나중에 크기/위치를 결정
    /// 커스텀 셀을 만들 때 반드시 required init?(coder:)와 override init(frame: CGRect) 이 두 개를 구현해야 함
    /// override init(frame: CGRect)는 "코드로 뷰(혹은 셀)를 만들 때, 초기화(셋업) 하는 생성자"다!
    ///  frame: .zero로 넣고 오토레이아웃 쓰는 건 “처음엔 크기 0, 실제 사이즈는 나중에 constraints로 결정”이라는 의미
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func setKFImage(url: String) {
        if let url = URL(string: url) {
            imageView.kf.setImage(with: url)
        }
    }
}
