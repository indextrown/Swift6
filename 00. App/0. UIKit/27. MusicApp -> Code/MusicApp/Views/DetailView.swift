//
//  DetailView.swift
//  MusicApp
//
//  Created by 김동현 on 3/13/25.
//

import UIKit

final class DetailView: UIView {
    
    // 이미지뷰 추가
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let songNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
//        label.textAlignment = .center
        return label
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
//        label.textAlignment = .center
        return label
    }()

    let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.textAlignment = .center
        return label
    }()

    let releaseDateLabl: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .darkGray
//        label.textAlignment = .center
        return label
    }()

    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution  = .fill
        sv.alignment = .center
        sv.spacing = 15
        return sv
    }()
    
    
    /*
     뷰의 고정된 레이아웃은 init(frame:)나 다른 초기 설정 단계에서 설정하고,
     동적 변경이 필요한 경우에만 updateConstraints()를 오버라이드하는 것이 좋습니다.
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupStackView()
        setConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStackView() {
        // 스택뷰 위에 뷰들 올리기
        stackView.addArrangedSubview(mainImageView)
        stackView.addArrangedSubview(songNameLabel)
        stackView.addArrangedSubview(artistNameLabel)
        stackView.addArrangedSubview(albumNameLabel)
        stackView.addArrangedSubview(releaseDateLabl)
        self.addSubview(stackView)
    }

    func setConstraints() {
        setMainImageView()
        setSongNameLabelConstraints()
        setStackViewConstraints()
        setArtistNameLabel()
        setAlbumNameLabel()
        setReleaseDateLabl()
    }
    
    func setMainImageView() {
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainImageView.widthAnchor.constraint(equalToConstant: 200),
            mainImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func setSongNameLabelConstraints() {
        songNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setArtistNameLabel() {
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setAlbumNameLabel() {
        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setReleaseDateLabl() {
        releaseDateLabl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

        





    

// MARK: - View
//    let mainImageView: UIImageView = {
//        let imageView = UIImageView()
//        return imageView
//    }()
//



//    let artistNameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.textColor = .darkGray
//        return label
//    }()
//
//    let albumNameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        return label
//    }()
//
//    let releaseDateLabl: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 10)
//        label.textColor = .darkGray
//        return label
//    }()
