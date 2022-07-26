//
//  AuthWebViewController.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 01/07/2022.
//

import UIKit
import WebKit

class AuthWebViewController: UIViewController {
    @IBOutlet weak var AuthWebView: WKWebView!
    
    var oauth: OAuth2 {
        guard let navCon = navigationController as? PatronumNavigationController else {
            fatalError("Some Shit 2")
        }
        return navCon.oauth
    }
    
    lazy var viewModel = {
        AuthWebViewModel(oauth: oauth)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AuthWebView.navigationDelegate = self
        oauth.authorize(using: &AuthWebView)
    }
    
}

extension AuthWebViewController:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if (viewModel.verifyAuth(webView: webView) == true){
            Task.init {
                try await viewModel.requestAccess()
                self.performSegue(withIdentifier: "goToApp", sender: self)
            }
        }else if (viewModel.verifyAuth(webView: webView) == false) {
            navigationController?.popViewController(animated: true)
        }
    }
}
