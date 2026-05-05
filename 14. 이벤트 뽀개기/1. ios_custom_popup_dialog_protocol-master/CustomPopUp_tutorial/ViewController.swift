//
//  ViewController.swift
//  CustomPopUp_tutorial
//
//  Created by Jeff Jeong on 2020/06/07.
//  Copyright © 2020 Tuentuenna. All rights reserved.
//

import UIKit
import WebKit

let notificationName = "btnClickNotification"

class ViewController: UIViewController, PopUpDelegate {
    
    
    @IBOutlet weak var myWebView: WKWebView!
    @IBOutlet weak var createPopUpBtn: UIButton!
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 노티피케이션 이라는 방송 수신기를 장착한다.
        NotificationCenter.default.addObserver(self, selector: #selector(loadWebView), name: NSNotification.Name(rawValue: notificationName), object: nil)
        
    }

    
    @objc fileprivate func loadWebView(){
        
        print("ViewController - loadWebView()")
        let myBlogAddress = URL(string: "https://blog.naver.com/kor216465")
        self.myWebView.load(URLRequest(url: myBlogAddress!))
    }
    
    @IBAction func onCreatePopUpBtnClicked(_ sender: UIButton) {
        print("ViewController - onCreatePopUpBtnClicked() called")
        
        // 스토리보드 가져오기
        let storyboard = UIStoryboard.init(name: "PopUp", bundle: nil)
        // 스토리보드를 통해 뷰컨트롤러 가져오기
        let customPopUpVC = storyboard.instantiateViewController(withIdentifier: "AlertPopUpVC") as! CustomPopUpViewController
        // 뷰컨트롤러가 보여지는 스타일
        customPopUpVC.modalPresentationStyle = .overCurrentContext
        // 뷰컨트롤러가 사라지는 스타일
        customPopUpVC.modalTransitionStyle = .crossDissolve
        
        customPopUpVC.subscribeBtnCompletionClosure = {
            print("컴플레션 블럭이 호출되었다.")
            let myChannelUrl = URL(string: "https://www.youtube.com/channel/UCutO2H_AVmWHbzvE92rpxjA?view_as=subscriber")
            self.myWebView.load(URLRequest(url: myChannelUrl!))
        }
        
        /// var myVC = self
        
        /// customPopUpVC.viewController = self
        customPopUpVC.myPopUpDelegate = self
        
        self.present(customPopUpVC, animated: true, completion: nil)
    }
    
    
    //MARK: - PopUpDelegate methods
    func onOpenChatBtnClicked(url: URL) {
        print("ViewController - onOpenChatBtnClicked() called")
        // let myChannelUrl = URL(string: "https://open.kakao.com/o/gxOOKJec")
        self.myWebView.load(URLRequest(url: url))
    }
  
    
}

//extension ViewController : PopUpDelegate {
//    //MARK: - PopUpDelegate methods
//      func onOpenChatBtnClicked() {
//          print("ViewController - onOpenChatBtnClicked() called")
//          let myChannelUrl = URL(string: "https://open.kakao.com/o/gxOOKJec")
//          self.myWebView.load(URLRequest(url: myChannelUrl!))
//      }
//}
