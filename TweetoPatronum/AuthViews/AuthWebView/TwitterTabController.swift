//
//  TwitterTabController.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 12/07/2022.
//

import UIKit

class TwitterTabController: UITabBarController {
    var oauth = OAuth()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        title = "Tweeto Patronum"
    }
}
