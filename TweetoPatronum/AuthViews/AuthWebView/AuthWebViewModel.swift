//
//  AuthWebViewModel.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 08/07/2022.
//

import Foundation
import WebKit

class AuthWebViewModel{
    var oauth: OAuth?
    
    private var authorizeEP = EndPoint(baseURL: "https://api.twitter.com/oauth/authorize", httpMethod: .GET, params: nil, auth: nil)
    private var oauthAccessTokenEP = EndPoint(baseURL: "https://api.twitter.com/oauth/access_token", httpMethod: .POST, params: nil, auth: nil)
    
    func authorizeUser(webView: inout WKWebView) {
//        authorizeEP.paramQuery = "oauth_token=\(oauth?.oauthToken ?? "")"
        authorizeEP.params = ["oauth_token":oauth?.oauthToken]
        guard let request = authorizeEP.networkRequest() else {
            print("Couldn't construct user authorization request.")
            return
        }
        webView.load(request)
    }
    
    func verifyAuth(webView: WKWebView) -> Bool?{
        if (webView.url?.absoluteString.contains("oauth_verifier")) == true{
            let oauthVerifierKeyValue = webView.url?.absoluteString.split(separator: "&").last
            let oauthVerifier = "\(oauthVerifierKeyValue?.split(separator: "=").last ?? "")"
            print("verifier is: \(oauthVerifier)")
            oauth?.collectVerifier(verifier: oauthVerifier)
            return true
        }else if (webView.url?.absoluteString.contains("https://mobile.twitter.com/")) == true {
            return false
        }else{
            return nil
        }
    }
    
    func requestAccess() async throws{
        let params: RequestParams = ["oauth_token":oauth?.oauthToken
                                     ,"oauth_verifier":oauth?.oauthVerifier]
        oauthAccessTokenEP.params = params
        guard let request = oauthAccessTokenEP.networkRequest() else {
            print("Couldn't Construct Network Request")
            return
        }

        do{
            let (data, _) = try await URLSession.shared.data(for: request)
            guard let oAuthResponse: OAuthResponseString = String(data: data, encoding: .utf8) else {
                print("Unable to read auth response")
                return
            }
            oauth?.collectAccessToken(accessResponse: oAuthResponse)
        }catch{
            print("Unable to process request. \(error)")
        }
    }
    
    init(oauth: OAuth) {
        self.oauth = oauth
    }

}
