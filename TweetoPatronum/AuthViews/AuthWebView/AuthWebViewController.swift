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
    
    var oauth: OAuth?
    
    lazy var viewModel = {
        AuthWebViewModel(oauth: oauth!)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AuthWebView.navigationDelegate = self
        Task.init {
            viewModel.authorizeUser(webView:&AuthWebView)
        }
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        Task.init {
//            try await viewModel.requestAccess()
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextView = segue.destination as? TwitterTabController
        nextView?.oauth = oauth!
    }
    
}

extension AuthWebViewController:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(webView.url)
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
