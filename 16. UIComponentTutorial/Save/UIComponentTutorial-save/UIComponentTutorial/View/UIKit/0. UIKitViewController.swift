//
//  UIKitViewController.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 5/18/25.
//

import UIKit

class UIKitViewController: UIViewController {
    
    // MARK: - UI Components
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    // UITableView(frame: .zero, style: .insetGrouped)
    
    private enum Section: Int, CaseIterable {
        case textField
        case textView
        case tableView
        case kingFisherView
        case calendarView
        
        var title: String {
            switch self {
            case .textField: return "UITextfield"
            case .textView: return "UITextView"
            case .tableView: return "UITableView"
            case .kingFisherView: return "Kingfisher"
            case .calendarView: return "calendar"
            }
        }
    }
    
    // ✅ 각 섹션의 셀 데이터를 배열로 선언
    private let textFieldItems = ["기본 텍스트필드 예제"]
    private let textViewItems = ["기본 텍스트뷰 예제"]
    private let tableViewItems = ["기본 테이블뷰", "기존 테이블뷰+제네릭"]
    private let kingfisherItems = ["kingFisher 예제"]
    private let calendarViewItems = ["기본 캘린더뷰"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // navigationController?.setNavigationBarHidden(true, animated: false)

        // ✅ NavigationBar를 숨길 경우, 추가 여백 제거
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 32
        }

        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
        tableView.contentInsetAdjustmentBehavior = .never
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegate()
        makeUI()
        setConstraints()
    }
    
    private func setDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func makeUI() {
        
        [tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 셀 등록
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension UIKitViewController: UITableViewDataSource {
    // 섹션추가시 필수
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    // 필수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .textField: return textFieldItems.count
        case .textView: return textViewItems.count
        case .tableView: return tableViewItems.count
        case .kingFisherView: return kingfisherItems.count
        case .calendarView: return calendarViewItems.count
        }
    }
    
    // 필수
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)!
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        
        switch section {
        case .textField:
            config.text = textFieldItems[indexPath.row]
        case .textView:
            config.text = textViewItems[indexPath.row]
        case .tableView:
            config.text = tableViewItems[indexPath.row]
        case .kingFisherView:
            config.text = kingfisherItems[indexPath.row]
        case .calendarView:
            config.text = calendarViewItems[indexPath.row]
        }
        
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
}

extension UIKitViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .textField:
            // indexPath.row에 따라 다른 ViewController도 가능
            let vc = TextFieldDemoViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .textView:
            let vc = ChatTextViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .tableView:
            switch indexPath.row {
                case 0:
                    let vc = DefaultTableViewController()
                    navigationController?.pushViewController(vc, animated: true)
                case 1:
                let vc = GenericDefaultTableViewController() // ✅ 추가된 뷰컨
                    navigationController?.pushViewController(vc, animated: true)
                default:
                    break
                }
        case .kingFisherView:
            let vc = KingfisherViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .calendarView:
            let vc = BasicCalendarViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

import SwiftUI

// MARK: - 네비게이션포함버전
extension UIKitViewController {
    struct VCWrapper: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UINavigationController {
            let root = UIKitViewController()
            let nav = UINavigationController(rootViewController: root)
            return nav
        }

        func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    }

    static func getRepresentablee() -> some View {
        VCWrapper()
            .ignoresSafeArea(.all, edges: .top) // ✅ 상단 safeArea 영향 제거
    }
}



#Preview {
    UIKitViewController()
}








//        if #available(iOS 15.0, *) {
//            tableView.sectionHeaderTopPadding = 0
//        }
//
//        tableView.contentInset = .zero
//        tableView.scrollIndicatorInsets = .zero
//        tableView.contentInsetAdjustmentBehavior = .never
//
//        // ✅ 핵심: tableHeaderView 설정 + 강제 적용
//        let header = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
//        tableView.tableHeaderView = header
//        tableView.tableHeaderView?.frame.size.height = CGFloat.leastNonzeroMagnitude
//        tableView.layoutIfNeeded()
//
//
