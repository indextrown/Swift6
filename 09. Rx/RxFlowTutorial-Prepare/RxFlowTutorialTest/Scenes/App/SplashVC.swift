//
//  SplashVC.swift
//  RxFlowTutorialTest
//
//  Created by Jeff Jeong on 2023/07/16.
//

import UIKit
import RxFlow
import RxCocoa
import RxSwift
import RxRelay

class SplashVC: UIViewController {

    @IBOutlet weak var focusedSegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
    }
    
    
    @IBAction func alreadyLoggedInStep(_ sender: Any) {
        print(#fileID, #function, #line, "- ")
    }
    
    @IBAction func loginIsRequiredStep(_ sender: Any) {
        print(#fileID, #function, #line, "- ")
        
        let loginVC = LoginVC.instantiate("Auth")
        let authNav = UINavigationController(rootViewController: loginVC)
        self.present(authNav, animated: true)

        // self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    
    @IBAction func navigateMainTab(_ sender: Any) {
        print(#fileID, #function, #line, "- ")
        let mainTabbar = UITabBarController()
        
        let homeVC = HomeVC.instantiate("Home")
        let homeNav = UINavigationController(rootViewController: homeVC)
        let homeTabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        homeNav.tabBarItem = homeTabBarItem
        
        let favoriteVC = FavoriteVC.instantiate("Favorite")
        let favoriteNav = UINavigationController(rootViewController: favoriteVC)
        let favoriteTabBarItem = UITabBarItem(title: "즐겨찾기", image: UIImage(systemName: "star.fill"), tag: 1)
        favoriteNav.tabBarItem = favoriteTabBarItem
        
        let profileVC = ProfileVC.instantiate("Profile")
        let profileNav = UINavigationController(rootViewController: profileVC)
        let profileTabBarItem = UITabBarItem(title: "프로필", image: UIImage(systemName: "person.fill"), tag: 2)
        profileNav.tabBarItem = profileTabBarItem
        
        mainTabbar.setViewControllers([homeNav, favoriteNav, profileNav], animated: true)
        // mainTabbar.tabBar.setItems([homeTabBarItem, favoriteTabBarItem, profileTabBarItem], animated: true)
        self.navigationController?.pushViewController(mainTabbar, animated: true)
        
    }
    
    
    @IBAction func handleBannedUser(_ sender: Any) {
        let bannedUserVC = BannedUserVC.instantiate("App")
        self.navigationController?.pushViewController(bannedUserVC, animated: true)
    }
    
}

