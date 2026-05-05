//
//  FirstViewController.swift
//  MusicApp
//
//  Created by 김동현 on 3/12/25.
//

import UIKit

final class FirstViewController: UIViewController {
    
    // 테이블뷰
    private let tableView = UITableView()
    
    // 테이블뷰 데이터를 표시할 배열
    var musicArray: [Music] = []
    
    // 네트워크 매니저
    let networkManager = NetworkManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarSetup()
        tableViewSetup()
        setupTableViewConstraints()
        setupDatas()
    }
    
    // 네비게이션바
    private func navigationBarSetup() {
        //view.backgroundColor = .black
        
        // 네비게이션 바에 large title 적용
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()                              // 불투명
        navigationBarAppearance.backgroundColor = .black                                     // 네비게이션바 배경 색상
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white] // 네비게이션바 텍스트 색상
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false
        title = "TableListView"
    }
    
    // 테이블뷰
    private func tableViewSetup() {
        tableView.dataSource = self
        tableView.delegate = self
        
        // 셀의 높이 설정
        tableView.rowHeight = 120
        
        // MARK: - 셀의 등록과정(스토리보드 사용시에는 스토리보드에서 자동등록됨)
        tableView.register(MusicTableViewCell.self, forCellReuseIdentifier: "MusicTableViewCell")
    }
    
    // 테이블뷰 오토레이아웃 설정
    func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    // 데이터
    private func setupDatas() {
        
        // 네트워킹 시작(비동기 코드)
        networkManager.fetchMusic(searchTerm: "jezz") { result in
            
            // MARK: - 클로저 내부에서 캡처 현상이 발생할 수 있어서
            switch result {
            case .success(let musicData):
                
                // 빈배열에 데이터 담기
                self.musicArray = musicData
                
                // 메인스레드에서 UI 적용
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("에러로그: \(error.localizedDescription)")
            }
        }
    }
}

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        return self.musicArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell", for: indexPath) as! MusicTableViewCell
        
        cell.imageUrl = musicArray[indexPath.row].imageUrl
        cell.songNameLabel.text = musicArray[indexPath.row].songName
        cell.artistNameLabel.text = musicArray[indexPath.row].artistName
        cell.albumNameLabel.text = musicArray[indexPath.row].albumName
        cell.releaseDateLabl.text = musicArray[indexPath.row].releaseDateString
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}

// MARK: - 테이블뷰 Cell 관련(선택적)
extension FirstViewController: UITableViewDelegate {
    
    /*
    // Cell 정확한 높이(유동적 변경 가능)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
     */
    
    // Cell 추정된 높이
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // 셀이 선택이 되었을때 어떤 동작을 할 것인지 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 다음화면으로 이동
        let detailVC = DetailViewController()
        detailVC.musicData = musicArray[indexPath.row]
        
        // MARK: - 선택된 셀의 이미지를 가져와 전달 -> 성공!!!
        if let cell = tableView.cellForRow(at: indexPath) as? MusicTableViewCell {
            detailVC.detailImage = cell.mainImageView.image
        }

        //show(detailVC, sender: nil)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}
#Preview {
    FirstViewController()
}
