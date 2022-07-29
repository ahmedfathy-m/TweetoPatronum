//
//  AuthWebViewModel.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 08/07/2022.
//

import Foundation
import WebKit

class AuthWebViewModel{
    weak var oauth: OAuth2?

    func verifyAuth(webView: WKWebView) -> Bool?{
        let currentURL = webView.url?.absoluteString
        if (currentURL?.starts(with: oauth!.callbackURL)) == true{
            guard let code = currentURL?.split(separator: "=").last else {return false}
            oauth?.collectAuthCode(code: "\(code)")
            return true
        }else if currentURL?.contains("twitter") == true{
            return nil
        }else{
            return false
        }
    }
    
    func requestAccess() async throws{
        try await oauth?.getAccessToken()
    }
    
    init(oauth: OAuth2) {
        self.oauth = oauth
    }

}
