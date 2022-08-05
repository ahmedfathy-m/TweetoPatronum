//
//  AuthScreenVC.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 04/08/2022.
//

import UIKit
import WebKit

class AuthScreenVC: UIViewController {
    var viewModel: AuthViewModel?
    var coordinator: AuthCoordinator?
    var webview = WKWebView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.navigationDelegate = self
        view.addSubview(webview)
        view.backgroundColor = .white
        viewModel?.authenticateUser(using: &webview)
    }
}

extension AuthScreenVC: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if (viewModel?.verifyAuth(webView: webView) == true){
                coordinator?.didLogInSuccessfully()
        }else if (viewModel?.verifyAuth(webView: webView) == false) {
            coordinator?.didFailToAuthenticate()
        }
    }
}
