//
//  DiaryListCell.swift
//  Diary
//
//  Created by 김동현 on 5/8/26.
//

import UIKit
import RxSwift
import SnapKit

final class DiaryListCell: UITableViewCell {
    static let id = "DiaryListCell"
    public var disposeBag = DisposeBag()
    
    private let stackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }() // stackView 장점: layout 안잡아도됨
    
    private let selectedImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        return imageView
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(selectedImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        selectedImageView.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
    }
    
    func apply(cellData: DiaryListCellData) {
        titleLabel.text = cellData.diary.title
        if let isSelected = cellData.isSelected {
            selectedImageView.isHidden = false
            selectedImageView.image = .init(systemName: isSelected ? "checkmark.seal.fill" : "checkmark.seal")
        } else {
            selectedImageView.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
