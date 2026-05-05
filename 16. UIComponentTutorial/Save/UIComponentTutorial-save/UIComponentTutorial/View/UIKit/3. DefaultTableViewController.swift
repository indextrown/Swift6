//
//  DefaultTableViewController.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 5/21/25.
//

import UIKit
import Fakery

// MARK: - 프로토콜
protocol ReuseIdentifiable {
    // 프로토콜에서 로직을 정의할 수 없어서 가져올 수 있도록 설정
    static var reuseIdentifier: String { get }
}
extension ReuseIdentifiable {
    // 로직에 대한 정의는 Extension에서 간능
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

// MARK: - ViewController
final class DefaultTableViewController: UIViewController {
    
    private let dummies = DummyData.getDumies()
    
    // MARK: - UI Component
    private let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        constraints()
        configureTableView()
    }
    
    private func makeUI() {
        view.backgroundColor = .white
        
        [tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureTableView() {
        self.tableView.register(CodeCell.self, forCellReuseIdentifier: CodeCell.reuseIdentifier)
        self.tableView.dataSource = self
    }
}

extension DefaultTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CodeCell.reuseIdentifier, for: indexPath) as? CodeCell else {
            return UITableViewCell()
        }
        
        let cellData: DummyData = dummies[indexPath.row]
        cell.configure(title: cellData.title, body: cellData.body)
        return cell
    }
}

#Preview {
    DefaultTableViewController()
}

// MARK: - Model
struct DummyData {
    let uuid: UUID
    let title: String
    let body: String
    
    init() {
        self.uuid = UUID()
        let faker = Faker(locale: "ko")
        let firstName = faker.name.firstName()  //=> "Emilie"
        let lastName = faker.name.lastName()    //=> "Hansen"
        
        let body = faker.lorem.paragraphs(amount: 5)
        
        self.title = "타이틀입니다: \(lastName) \(firstName)"
        self.body = "바디입니다: \(body)"
    }
    
    static func getDumies(_ count: Int = 10) -> [DummyData] {
        return (1...count).map { _ in DummyData() }
    }
}





// MARK: - CodeCell
final class CodeCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "본문"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    // 원래는 awakefromnib을 타지만 코드로 UI를 진행한다면 awakefromnib을 타지 않는다.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier) /// 부모의 로직을 싱행시키는 의미
        makeUI()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, body: String) {
        titleLabel.text = title
        bodyLabel.text = body
    }
    
    private func makeUI() {
        self.backgroundColor = .systemYellow
        
        [titleLabel, bodyLabel].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func constraints() {
        // 타이틀 라벨 설정
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
        ])
        
        // 바디 라벨 설정
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            bodyLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            bodyLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            bodyLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
}


extension UITableViewCell: ReuseIdentifiable {}


// MARK: - Cell 프리뷰
#if DEBUG
import SwiftUI

extension UIView {
    private struct ViewRepresentable: UIViewRepresentable {
        let uiView: UIView
        func updateUIView(_ uiView: UIViewType, context: Context) {
        }
        func makeUIView(context: Context) -> some UIView {
            uiView
        }
    }
    
    func getPreview() -> some View {
        ViewRepresentable(uiView: self)
    }
}
#endif

#if DEBUG
import SwiftUI

struct CodeCell_PreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        CodeCell().getPreview()
            .previewLayout(.fixed(width: 200, height: 100))
    }
}
#endif
