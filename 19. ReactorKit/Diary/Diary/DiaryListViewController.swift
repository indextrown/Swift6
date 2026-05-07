//
//  DiaryListViewController.swift
//  Diary
//
//  Created by 김동현 on 5/7/26.
//

import UIKit
import RxSwift
import RxCocoa // UI에 대한 이벤트를 쉽게 연결하는 기능 제공
import SnapKit
import ReactorKit
import CoreData

class DiaryListViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let writeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        return button
    }() // 클로저를 즉시 실행하면 “실행 결과(return 값)”의 타입이 최종 값 타입이 된다
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
        
        writeButton.rx.tap
            .bind { [weak self] in
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let viewContext = appDelegate.persistentContainer.viewContext
                
                let writeVC = DiaryViewController(reactor: DiaryWriteViewReactor(
                    initialState: .init(),
                    coreData: DiaryCoreData(viewContext: viewContext))
                )
                self?.navigationController?.pushViewController(
                    writeVC,
                    animated: true
                )
            }.disposed(by: disposeBag)
    }

    private func setUI() {
        view.backgroundColor = .white
        navigationItem.setRightBarButtonItems(
            [UIBarButtonItem(customView: writeButton)],
            animated: true
        )
    }
    
    private func setConstraints() {
        
    }

}

