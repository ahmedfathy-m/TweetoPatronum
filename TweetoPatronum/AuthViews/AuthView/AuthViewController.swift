//
//  AuthViewController.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 30/06/2022.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {
    let oauth = OAuth()
    
    lazy var viewModel = {
        AuthViewModel(oauth: oauth)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue){}
    
    @IBAction func loginAction(_ sender: UIButton) {
        Task.init {
            let authSuccess = try await viewModel.requestAuthToken()
            authSuccess ? performSegue(withIdentifier: "authorizeID", sender: self) : nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationView = segue.destination as? AuthWebViewController
        destinationView?.oauth = oauth
    }
}
