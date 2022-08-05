//
//  AppCoordinator.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 02/08/2022.
//

import UIKit

protocol AuthCoordinatorDelegate: AnyObject{
    func coordinatorDidAuthenticate()
}

final class AppCoordinator: BaseCoordinator {
    var mainCoordinator:MainCoordinator? = nil
    var authCoordinator:AuthCoordinator? = nil
    
    private var hasCredentials:Bool{
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
    
    override func start() {
        if hasCredentials {
            mainCoordinator = MainCoordinator(with: navigationController)
            childCoordinators.append(mainCoordinator!)
            mainCoordinator?.oauth = self.oauth
            mainCoordinator?.start()
        }else{
            authCoordinator = AuthCoordinator(with: navigationController)
            childCoordinators.append(authCoordinator!)
            authCoordinator?.oauth = self.oauth
            authCoordinator?.delegate = self
            authCoordinator?.start()
        }
    }

}

extension AppCoordinator: AuthCoordinatorDelegate {
    func coordinatorDidAuthenticate() {
        removeCoordinator(coordinator: authCoordinator!)
        start()
    }
}
