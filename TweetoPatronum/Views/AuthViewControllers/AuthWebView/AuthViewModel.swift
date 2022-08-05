//
//  AuthViewModel.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 04/08/2022.
//

import Foundation
import WebKit

class AuthViewModel{
    var oauth: OAuth2?

    func verifyAuth(webView: WKWebView) -> Bool?{
        let currentURL = webView.url?.absoluteString
        if (currentURL?.starts(with: oauth!.callbackURL)) == true{
            guard let code = currentURL?.split(separator: "=").last else {return false}
            oauth?.collectAuthCode(code: "\(code)")
            Task.init {
                try await requestAccess()
            }
            return true
        }else if currentURL?.contains("twitter") == true{
            return nil
        }else{
            return false
        }
    }
    
    func authenticateUser(using webview: inout WKWebView) {
        oauth?.authorize(using: &webview)
    }
    
    func requestAccess() async throws{
        try await oauth?.getAccessToken()
    }
    
    init(oauth: OAuth2) {
        self.oauth = oauth
    }

}
