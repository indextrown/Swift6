//
//  UserTableViewCell.swift
//  MVVM+CleanArchitecture+Rx
//
//  Created by 김동현 on 4/5/25.
//

import UIKit
import Kingfisher
import RxSwift

final class UserTableViewCell: UITableViewCell, UserListCellProtocol {
    static let id = "UserTableViewCell"
    public var disposeBag = DisposeBag()
    
    private let userImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - public 이유 - ViewController에서 접근하여 사용하기 위헤
    // MARK: - disposeBag이유 - VC에서 셀의 disposeBag 사용하기 위해?
    public let favoriteButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = .systemRed
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(nameLabel)
        // 이벤트 잘 발생되도록 contentView에 추가
        contentView.addSubview(favoriteButton)
        
        userImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(80).priority(.high)
        }
        
        // label은 높이 지정안해도 됨
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView) // userTop기준
            $0.leading.equalTo(userImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(-20)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func apply(cellData: UserListCellData) {
        guard case let .user(user, isFavorite) = cellData else { return }
        userImageView.kf.setImage(with: URL(string: user.imageURL))
        nameLabel.text = user.login
        favoriteButton.isSelected = isFavorite
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
