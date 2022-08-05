//
//  AuthCoordinator.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 03/08/2022.
//

import UIKit

class AuthCoordinator: BaseCoordinator {
    weak var delegate: AuthCoordinatorDelegate?
    
    override func start() {
        showWelcomeScreen()
    }

    fileprivate func showWelcomeScreen(){
        let welcomeVC = WelcomeViewController()
        welcomeVC.coordinator = self
        navigationController.pushViewController(welcomeVC, animated: true)
    }
    
    func showAuthScreen(){
        let authVC = AuthScreenVC()
        authVC.coordinator = self
        authVC.viewModel = AuthViewModel(oauth: oauth)
        navigationController.pushViewController(authVC, animated: true)
    }
    
    func didLogInSuccessfully(){
        delegate?.coordinatorDidAuthenticate()
    }
    
    func didFailToAuthenticate(){
        print("DidFail")
    }
}
