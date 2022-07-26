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
//        print(oauth.oAuthToken?.accessToken)
        return TwitterHandler(oauth)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        title = "Tweeto Patronum"
    }
}
