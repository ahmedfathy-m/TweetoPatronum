//
//  WelcomeViewController.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 04/08/2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var coordinator: AuthCoordinator?

    fileprivate func makeUIButton() {
        view.backgroundColor = .white
        let width:CGFloat = 120.0
        let height:CGFloat = 30.0
        let screenBounds = UIScreen.main.bounds
        let welcomeButton = UIButton(frame: CGRect(x: (screenBounds.width - width) / 2.0, y: 80.0, width: width, height: height))
        welcomeButton.layer.cornerRadius = welcomeButton.frame.height / 2
        welcomeButton.backgroundColor = .systemBlue
        welcomeButton.setTitle("Welcome", for: .normal)
        welcomeButton.setTitleColor(.white, for: .normal)
        welcomeButton.addTarget(self, action: #selector(welcomeButtonPressed(sender:)), for: .touchUpInside)
        view.addSubview(welcomeButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUIButton()
    }
    
    @objc func welcomeButtonPressed(sender: UIButton){
        coordinator?.showAuthScreen()
    }
}
