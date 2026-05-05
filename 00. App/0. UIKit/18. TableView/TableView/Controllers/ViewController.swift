//
//  ViewController.swift
//  TableView
//
//  Created by 김동현 on 2/28/25.
//

import UIKit

// MARK: - 테이블 뷰 사용시 프로토콜 채택해야함 - UITableViewDataSource(tableView-viewController통신 프로토콜)
// tableView -> viewController: 셀(컨텐츠) 몇개 표시?
// tableView -> viewController: 셀에 대한 내부컨텐츠를 어떻게 표시?
// viewController -> tableView: 컨텐츠 10개표시, 내용물은 ~하게 표시해
final class ViewController: UIViewController, UITableViewDataSource {
    
    var moviesArray: [Movie] = [
        Movie(
            movieImage: UIImage(named: "batman.png"),
            movieName: "배트맨",
            movieDescription: "배트맨이 출현하는 영화"),
        Movie(
            movieImage: UIImage(named: "captain.png"),
            movieName: "캡틴 아메리카",
            movieDescription: "캡틴 아메리카의 기원. 캡틴 아메리카는 어떻게 탄생하게 되었을까?"),
        Movie(
            movieImage: UIImage(named: "ironman.png"),
            movieName: "아이언맨",
            movieDescription: "토니 스타크가 출현, 아이언맨이 탄생하게된 계기가 재미있는 영화"),
        Movie(
            movieImage: UIImage(named: "thor.png"),
            movieName: "토르",
            movieDescription: "아스가르드의 후계자 토르가 지구에 오게되는 스토리"),
        Movie(
            movieImage: UIImage(named: "hulk.png"),
            movieName: "헐크",
            movieDescription: "브루스 배너 박사의 실험을 통해 헐크가 탄생하게 되는 영화"),
        Movie(
            movieImage: UIImage(named: "spiderman.png"),
            movieName: "스파이더맨",
            movieDescription: "피터 파커 학생에서 스파이더맨이 되는 과정을 담은 스토리"),
        Movie(
            movieImage: UIImage(named: "blackpanther.png"),
            movieName: "블랙펜서",
            movieDescription: "와칸다의 왕위 계승자 티찰과 블랙펜서가 되다."),
        Movie(
            movieImage: UIImage(named: "doctorstrange.png"),
            movieName: "닥터스트레인지",
            movieDescription: "외과의사 닥터 스트레인지가, 히어로가 되는 과정을 담은 영화"),
        Movie(
            movieImage: UIImage(named: "guardians.png"),
            movieName: "가디언즈 오브 갤럭시",
            movieDescription: "빌런 타노스에 맞서서 세상을 지키려는 가오겔 멤버들")
    ]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate와 유사함 but 이름만 dataSource라고 애플이 지정해둠
        tableView.dataSource = self // self는 viewController(테이블뷰의 대리자는 viewController이다)
        tableView.rowHeight = 120
    }
    
    // 몇개의 컨텐츠를 만들면 되는지 알려주는 메시지(tableView가 viewController에게 물어보는 내용이다)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    // 몇번째 행에있는 셀을 어떠한 방식으로 표시해라고 알려주는 메시지
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 기존에 스토리보드로 만든 cell을 꺼내서 쓸거야. 문자열은 스토리보드 셀에 입력해두자.
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell // 타입캐스팅
        
        let movie = moviesArray[indexPath.row]
        
        // 코드 설정
        cell.mainImageView.image = movie.movieImage
        cell.movieNameLabel.text = movie.movieName
        cell.descriptionLabel.text = movie.movieDescription
        cell.selectionStyle = .none
        
        return cell
    }
}

