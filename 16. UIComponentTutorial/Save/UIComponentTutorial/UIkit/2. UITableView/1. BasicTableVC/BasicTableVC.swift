//
//  BasicListVC.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 6/1/25.
//

import UIKit
import Fakery

// MARK: - ViewController
final class BasicTableVC: UIViewController {
    
    private let dummies = DummyData.getDumies()
    
    // MARK: - UI Component
    private let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView()
        makeUI()
        constraints()
    }
    
    private func settingTableView() {
        self.tableView.register(CodeCell.self, forCellReuseIdentifier: CodeCell.reuseIdentifier)
        self.tableView.dataSource = self
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
}

extension BasicTableVC: UITableViewDataSource {
    
    /// 테이블뷰의 섹션별 행 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummies.count
    }
    
    /// 각 셀에 들어갈 데이터를 설정하는 메서드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// 셀을 재사용 큐에서 가져오고, 실패 시 기본 셀 반환
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CodeCell.reuseIdentifier, for: indexPath) as? CodeCell else {
            return UITableViewCell()
        }
        
        /// 현재 행에 해당하는 데이터 추출
        let cellData: DummyData = dummies[indexPath.row]
        /// 셀에 데이터 바인딩(제목, 본문)
        cell.bindCell(cellData)
        return cell
    }
}



#Preview {
    BasicTableVC()
}


/*
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
*/
