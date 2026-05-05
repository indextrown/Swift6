//
//  DetailViewController.swift
//  MemberList
//
//  Created by 김동현 on 3/10/25.
//

import UIKit
import PhotosUI

final class DetailViewController: UIViewController {
    
    private let detailView = DetailView()
    
    var member: Member?

    // viewDidLoad보다 먼저 호출됨, 완전 재정의 부분이라 super 필요 x
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupButtonAction()
        setupTapGesture()
    }
    
    // ViewController에서 member 받아온다
    private func setupData() {
        detailView.member = member
    }
    
    // update 버튼의 동작은 view에서 지원하지 않아서 viewController에서 해줘야한다
    // 화면이동 present메서드가 viewController에 구현되있다(target을 viewController에서 설정해줘야한다)
    // 뷰에 있는 버튼의 타겟 설정
    func setupButtonAction() {
        detailView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    
    // MARK: - 이미지 뷰가 눌렸을 때 동작 설정
    
    // 제스처 설정(이미지뷰가 눌린다면 실행)
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        detailView.mainImageView.addGestureRecognizer(tapGesture)
        detailView.mainImageView.isUserInteractionEnabled = true
    }
    
    @objc func touchUpImageView() {
        print("이미지뷰 터치")
        setupImagePicker()
    }
    
    func setupImagePicker() {
        // 기본설정 세팅
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0 // 0으로하면 사진첩에서 무한대로 가지고 올 수 있다
        configuration.filter = .any(of: [.images, .videos])
        
        // 기본설정을 가지고, 피커뷰컨트롤러 생성
        let picker = PHPickerViewController(configuration: configuration)
        // 피커뷰 컨트롤러의 대리자 설정
        picker.delegate = self
        // 피커뷰 띄우기
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        print("버튼이 눌림")
        
        // [1] 멤버가 없다면 즉 새로운 멤버를 추가하는 화면
        if member == nil {
            // 입력이 안되어 있다면 빈문자열로 저장
            let name = detailView.nameLabel.text ?? ""
            let age = Int(detailView.ageTextField.text ?? "")
            let phoneNumber = detailView.phoneNumberTextField.text ?? ""
            let address = detailView.addressTextField.text ?? ""
            
            // 새로운 멤버 구조체 생성
            var newMember = Member(name: name, age: age, phone: phoneNumber, address: address)
            newMember.memberImage = detailView.mainImageView.image
            
            // MARK: 1) 델리게이트 방식이 아닌 구현
            // 전화면구하기: 가장마지막이 count - 1이므로 count -1 -1 즉 count - 2가 된다
            let index = navigationController!.viewControllers.count - 2
            
            // 전 화면에 접근하기 위함
            let vc = navigationController?.viewControllers[index] as! ViewController
            
            // 전 화면의 모델에 접근해서 멤버를 업데이트
            vc.memberListManager.makeNewMember(newMember)
            
            // MARK: 2) 델리게이트 방식으로 구현가능
            
            // [2] 멤버가 있다면 멤버의 내용을 업데이트 하기 위한 설정
        } else {
            // 이미지뷰에 있는 것을 그대로 다시 멤버에 저장
            member!.memberImage = detailView.mainImageView.image
            
            let memberId = Int(detailView.memberIdTextField.text!) ?? 0
            member!.name = detailView.nameTextField.text ?? ""
            member!.age = Int(detailView.nameTextField.text ?? "") ?? 0
            member?.phone = detailView.phoneNumberTextField.text ?? ""
            member!.address = detailView.addressTextField.text ?? ""
            
            // 뷰에도 바뀐 멤버를 전달(뷰컨트롤러 ===> 뷰)
            detailView.member = member
            
            // MARK: 1) 델리게이트 방식이 아닌 구현
            // 전화면구하기: 가장마지막이 count - 1이므로 count -1 -1 즉 count - 2가 된다
            let index = navigationController!.viewControllers.count - 2
            
            // 전 화면에 접근하기 위함
            let vc = navigationController?.viewControllers[index] as! ViewController
            
            // 전 화면의 모델에 접근해서 멤버를 업데이트
            vc.memberListManager.updateMember(index: memberId, member!)
            
            
            // MARK: 2) 델리게이트 방식으로 구현가능
        }
        
        // 일처리를 다하고 전화면으로 돌아가기
        self.navigationController?.popViewController(animated: true)
    }
}

// delegate 패턴이므로 대리자 설정을 해줘야 한다
extension DetailViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 피커뷰 dismiss
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    // 이미지뷰에 표시
                    self.detailView.mainImageView.image = image as? UIImage
                }
            }
        } else {
            print("이미지 로드 에러!!")
        }
    }
}
