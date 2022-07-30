//
//  TwitterTabController.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 12/07/2022.
//

import UIKit

class TwitterTabController: UITabBarController {
    var oauth: OAuth2 {
        guard let navCon = navigationController as? PatronumNavigationController else {
            fatalError("Some Shit")
        }
        print("assigned oauth")
        return navCon.oauth
    }
    lazy var handler: TwitterHandler = {
        print("assigned handler")
        return TwitterHandler(oauth)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        title = "Tweeto Patronum"
        let logoutButton = UIButton()
        logoutButton.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        logoutButton.setTitleColor(.black, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        let barButton = UIBarButtonItem()
        barButton.customView = logoutButton
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func logoutButtonPressed(sender:UIButton) {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.logOut()
        }))
        self.present(alert, animated: true)
    }
    func logOut() {
        Task.init {
            try await oauth.revokeAccessToken()
            if oauth.revokeStatus.revoked == true {
                UserDefaults.standard.removeObject(forKey: "AuthCredentials")
                UserDefaults.standard.removeObject(forKey: "Token Valid Until")
                let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! AuthViewController
                self.navigationController?.setViewControllers([loginVC], animated: true)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
