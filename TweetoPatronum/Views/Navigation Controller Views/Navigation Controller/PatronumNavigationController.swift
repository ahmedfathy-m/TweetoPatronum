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
        if hasCredentials() {
            let tcIdentifier = "TwitterTabController"
            let targetTC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: tcIdentifier) as! TwitterTabController
            self.setViewControllers([targetTC], animated: true)
        }
    }
    
    func hasCredentials()-> Bool{
        guard let oauthTokenData = UserDefaults.standard.value(forKey: "AuthCredentials") as? Data else {return false}
        print("Has Data")
        guard let oauthToken = try? JSONDecoder().decode(OAuthToken.self, from: oauthTokenData) else {return false}
        guard let validityCounter = UserDefaults.standard.value(forKey: "Token Valid Until") as? Int else {return false}
        print(validityCounter)
        print(Date.now.timeIntervalSince1970)
        oauth.updateTokenValidity(with: validityCounter)
        print(oauthToken)
        oauth.oAuthToken = oauthToken
        return true
    }
}
