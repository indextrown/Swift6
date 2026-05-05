//
//  ViewController.swift
//  MemberList
//
//  Created by 김동현 on 3/9/25.
//

/*
 테이블뷰
 - View를 따로 만들지 않는다, Cell만 코드로 구현
 - 이유: Cell이 뷰의 역할을 하기도 하고 테이블뷰 자체는 View로써 특정한 기능을 가지지 않기 때문
 */

import UIKit

final class ViewController: UIViewController {
    
    // 1. 테이블뷰
    private let tableView = UITableView()
    
    // 6. 비즈니스 로직 관리/접근을 위한 매니저 생성
    var memberListManager = MemberListManager()
    
    // 네비게이션바에 넣기 위한 버튼
    lazy var plusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        return button
    }()
    
    // 멤버를 추가하기 위한 다음 화면으로 이동
    @objc func plusButtonTapped() {
        // 다음화면으로 이동(멤버는 전달안함)
        let detailVC = DetailViewController()
        
        // 화면 이동
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 10
        setupData()
        
        // 12
        setupTableView()
        
        // 8
        setupNaviBar()
        
        // 3. 오토레이아웃 세팅
        setupTableConstraints()
        
    }
    
    // 다른화면으로 갔다가 다시 돌아와서 이 화면이 나타나면 호출되는 메서드
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // 9. 비즈니스데이터 설정
    func setupData() {
        // 배열에 데이터가 생기도록
        memberListManager.makeMemberListCreate()
    }
    
    // 11
    func setupTableView() {
        // 5. tableView의 대리자(이지만 특정한 이름을 가진 dataSource)를 self(나)로 설정(viewController가 대리자 역할을 하게됨)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60 // 셀의 높이
        
        // 셀을 등록
        // AnyClass타입: 메타타입(함수의 파라미터 타입)
        // 실제로 함수를 호출하여 argument값을 주려면 타입 인스턴스 형태로 줘야함 MyTableViewCell
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "MemberCell")
    }
    
    // 7. 네비게이션 바 세팅
    func setupNaviBar() {
        title = "회원 목록"
        
        // 네비게이션 설정화면
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // 불투명
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // 네비게이션바 오른쪽 상단 버튼 설정
         self.navigationItem.rightBarButtonItem = self.plusButton
    }

    // 2. 테이블뷰와 관련된 오토레이아웃을 코드로 작성
    func setupTableConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
}

// 4. 필수적으로 구현해야하는 델리게이트 패턴을 사용하기 위해 확장
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberListManager.getMemberList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 그냥 공식처럼 생각하고 복붙하기
        // 1) 등록한 셀을 꺼내서 사용가능
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MyTableViewCell
        //cell.mainImageView.image = memberListManager.getMemberList()[indexPath.row].memberImage
        
        /* 개선을 위해 member만 전달하면됨
        cell.mainImageView.image = memberListManager[indexPath.row].memberImage
        cell.memberNameLabel.text = memberListManager[indexPath.row].name
        cell.addressLabel.text = memberListManager[indexPath.row].address
         */
        cell.member = memberListManager[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
}

// 화면이동을 위해 확장(대리자 설정해주저)
extension ViewController: UITableViewDelegate {
    // 선택적인 메서드
    // 테이블뷰에서 셀이 눌렸을 때 메서드를 통해 동작이 전달된다
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 다음화면으로 넘어가는 코드
        let detailVC = DetailViewController()
        
        // 데이터 전달
        let array = memberListManager.getMemberList()
        detailVC.member = array[indexPath.row]
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
