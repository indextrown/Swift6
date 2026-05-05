//
//  MusicTableViewCell.swift
//  MusicApp
//
//  Created by 김동현 on 3/12/25.
//

import UIKit

class MusicTableViewCell: UITableViewCell {
    
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    // MARK: - View
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.backgroundColor = .systemGray5  // 시각 확인용 임시 색상
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let songNameLabel: UILabel = {
        let label = UILabel()
        //label.text = "노래 제목"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        //label.text = "가수 이름"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let albumNameLabel: UILabel = {
        let label = UILabel()
        //label.text = "앨범 이름"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let releaseDateLabl: UILabel = {
        let label = UILabel()
        //label.text = "발매일"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution  = .fill
        sv.alignment = .fill
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupStackView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStackView() {
        
        self.contentView.addSubview(mainImageView)
        self.contentView.addSubview(stackView)
        stackView.addArrangedSubview(songNameLabel)
        stackView.addArrangedSubview(artistNameLabel)
        stackView.addArrangedSubview(albumNameLabel)
        stackView.addArrangedSubview(releaseDateLabl)
    }
    
    // MARK: - Constraints
    func setConstraints() {
        setMainImageViewConstraints()
        setStackViewConstraints()
    }
    
    func setMainImageViewConstraints() {
        NSLayoutConstraint.activate([
            mainImageView.widthAnchor.constraint(equalToConstant: 100),
            mainImageView.heightAnchor.constraint(equalToConstant: 100),
            
            mainImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            mainImageView.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -20),
            mainImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }

    func setStackViewConstraints() {
        NSLayoutConstraint.activate([
            // stackView를 mainImageView 오른쪽에 위치시키기
            stackView.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            // stackView의 수직 중앙 정렬
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // 이미지 url -> 이미지요청(세팅) 메서드
    private func loadImage() {
        guard let urlString = self.imageUrl, let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            // MARK: - Data(contentsOf: url)가 동기적이라 dispatchqueue로 비동기처리해야함
            guard let data = try? Data(contentsOf: url) else { return }
            
            // 오래걸리는 작업이 일어나는 동안에 url 바뀔 가능성 제거
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
                
            }
        }
    }
    
    
    /*
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
     */
}

#Preview {
    MusicTableViewCell()
}
