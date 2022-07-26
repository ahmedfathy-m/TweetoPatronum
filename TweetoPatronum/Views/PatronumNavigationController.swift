//
//  PatronumNavigationController.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 22/07/2022.
//

import UIKit

class PatronumNavigationController: UINavigationController {
    let oauth = OAuth2(id: "blh4NEl6N04wQXlBWmZwcWRJT1Q6MTpjaQ", callback: "https://www.blank.org")
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
