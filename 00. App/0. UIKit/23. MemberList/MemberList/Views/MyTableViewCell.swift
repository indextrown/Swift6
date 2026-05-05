//
//  MyTableViewCell.swift
//  MemberList
//
//  Created by 김동현 on 3/9/25.
//

import UIKit

final class MyTableViewCell: UITableViewCell {
    
    // 개선방법 - 속성감시자 사용
    var member: Member? {
        // member라는 저장속성을 항상 감시하여 변수가 변화면 바로바로 didset 실행하여 변한 상태를 cell에 표시 가능
        didSet {
            guard var member = member else { return }
            mainImageView.image = member.memberImage
            memberNameLabel.text = member.name
            addressLabel.text = member.address
        }
    }
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let memberNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 5
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // UITableCell을 만들 때 기본적으로 세팅해주는 생성자(여기에 오토레이아웃 적용하면됨)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        // 저장속성을 세팅해주는거를 상위에서 정의되어 있으면 상위에 다시 위임해야하기 때문
        // 상위에 지정생성자, 필수생성자가 있을 때 지정생성자를 재정의하여 생성자를 재구현한다면 상위에 있는 필수생성자를 구현해줘야한다
        // 이유: 지정생성자를 재정의한다는거는 저장속성을 만들었을 수 있고 저장속성을 세팅하기위해 지정생성자를 재정의하는거다
        // 이때 필수생성자가 자동으로 상속되지 않기 때문에 필수생성자를 반드시 구현해야한다
        super.init(style: .default, reuseIdentifier: "")
        
        // 스택뷰 세팅
        setupStackView()
    }
    
    func setupStackView() {
        self.addSubview(mainImageView)
        
        // 셀 위에 스택뷰 올리기
        self.addSubview(stackView)
        
        // 스택뷰 위에 뷰들 올리기
        stackView.addArrangedSubview(memberNameLabel)
        stackView.addArrangedSubview(addressLabel)
    }
    
    // 필수생성자(상위에서 특정역할을 하기 때문에..반드시 구현해야한다)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     
    // storyboard로 만들 때 viewDidload와 비슷한 역할(코드구현시 무시)
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
     
     */
    
    // MARK: - 오토레이아웃을 정하는 정확한 시점
    override func updateConstraints() {
        setConstraints()
        super.updateConstraints()
    }
    
    // 오토레이아웃 관련 코드
    func setConstraints() {
        NSLayoutConstraint.activate([
            mainImageView.heightAnchor.constraint(equalToConstant: 40),
            mainImageView.widthAnchor.constraint(equalToConstant: 40),
            mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            mainImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            memberNameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.mainImageView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.mainImageView.bottomAnchor)
        ])
    }
    
    // 셀의 레이아웃의 확정된 후, 이미지 뷰를 원형으로 보이도록 만드는 후처리 역할
    // 완벽한 원을 그리기위해 실제로 넓이가 정확히 결정되는 순간이 layoutSubviews() 이후이다. 여기서 프레임에 대한 넓이를 구하고 절반으로 나눈다
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mainImageView.clipsToBounds = true
        self.mainImageView.layer.cornerRadius = self.mainImageView.frame.width / 2
    }

}
