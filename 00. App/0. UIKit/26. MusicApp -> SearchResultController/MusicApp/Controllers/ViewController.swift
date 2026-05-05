//
//  ViewController.swift
//  MusicApp
//
//  Created by 김동현 on 3/12/25.
//

import UIKit

class ViewController: UIViewController {
    
    // 서치 컨트롤러 생성 -> Navigation Iten에 할당
    //let searchController = UISearchController()
    
    // 서치 Result 컨트롤러
    let searchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController)

    @IBOutlet weak var musicTableView: UITableView!
    
    // 네트워크 매니저(싱글톤)
    // networkManager: 데이터 영역
    // 싱글톤 객체: heap
    var networkManager = NetworkingManager.shared

    // 음악 데이터를 다루기 위한 빈배열
    private var musicArrays: [Music] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupDatas()
        setupSearchBar()
    }
    
    func setupTableView() {
        musicTableView.dataSource = self
        musicTableView.delegate = self
        // nib파일 등록
        musicTableView.register(UINib(nibName: Cell.musicCellIdentifier, bundle: nil), forCellReuseIdentifier: Cell.musicCellIdentifier)
    }
    
    func setupSearchBar() {
        self.title = "Music Search"
        navigationItem.searchController = searchController
        
        // 1) 단순 서치바의 사용(delegate pattern)
        // searchController.searchBar.delegate = self
        
        // 2 서치(결과) 컨트롤러의 사용(복잡한 구현 가능)
        // ---> 글자마다 검색 기능 + 새로운 화면을 보여주는것도 가능
        searchController.searchResultsUpdater = self
    }

    func setupDatas() {
        
        // 네트워킹 시작(비동기 코드)
        networkManager.fetchMusic(searchTerm: "jezz") { result in
            
            // MARK: - 클로저 내부에서 캡처 현상이 발생할 수 있어서
            
            switch result {
            case .success(let musicData):
                
                // 빈배열에 데이터 담기
                self.musicArrays = musicData
                
                // 메인스레드에서 UI 적용
                DispatchQueue.main.async {
                    self.musicTableView.reloadData()
                }
            case .failure(let error):
                print("에러로그: \(error.localizedDescription)")
            }
        }
    }

}

// MARK: - 테이블뷰 관련(필수)
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 여러번 호출됨, 처음에는 배열개수 0, 네트워크가 오래 걸리기 떄문
        // 빈테이블을 그리고 나서 테이블을 reload
        // print(#function)
        return self.musicArrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 테이블뷰에 접근하여 등록한 cell을 꺼내서 사용하겠다 + 타입캐스팅
        let cell = musicTableView.dequeueReusableCell(withIdentifier: Cell.musicCellIdentifier, for: indexPath) as! MusicCell
        
        // MARK: - 셀에서 이미지표시할떄 오래 걸리는 작업(비동기)은 전달 x -> url로만 전달하고 셀에서 직접 이미지를 로드하는게 좋다  
        cell.imageUrl = musicArrays[indexPath.row].imageUrl
        cell.songNameLabel.text = musicArrays[indexPath.row].songName
        cell.artistNameLabel.text = musicArrays[indexPath.row].artistName
        cell.albumNameLabel.text = musicArrays[indexPath.row].albumName
        cell.releaseDateLabl.text = musicArrays[indexPath.row].releaseDateString
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - 테이블뷰 Cell 관련(선택적)
extension ViewController: UITableViewDelegate {
    
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
}

/*
// MARK: - 1) 단순 search bar
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 다시 빈 배열로 만들기
        self.musicArrays = []
        
        // 네트워킹 시작
        networkManager.fetchMusic(searchTerm: searchText) { result in
            switch result {
            case .success(let musicDatas):
                self.musicArrays = musicDatas
                DispatchQueue.main.async {
                    self.musicTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /*
    // 검색 버튼을 눌렀을 때 호출되는 메서드
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        print(searchText)
        
        // 다시 빈 배열로 만들기
        self.musicArrays = []
        
        // 네트워킹 시작
        networkManager.fetchMusic(searchTerm: searchText) { result in
            switch result {
            case .success(let musicDatas):
                self.musicArrays = musicDatas
                DispatchQueue.main.async {
                    self.musicTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        // 키보드 내리기?
        self.view.endEditing(true)
    }
     */
}
*/

// MARK: - 2) 검색하는동안 (새로운 화면을 보여주는) 복잡한 내용 구현 간으
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("서치바에 입력되는 단어", searchController.searchBar.text!)
        
        let vc = searchController.searchResultsController as! SearchResultViewController
        vc.searchTerm = searchController.searchBar.text ?? ""
    }
}
