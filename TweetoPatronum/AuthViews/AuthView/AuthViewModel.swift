//
//  AuthViewModel.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 07/07/2022.
//

import Foundation
import WebKit

class AuthViewModel {
    var oauth: OAuth?
    
    private var requestTokenEP = EndPoint(baseURL: "https://api.twitter.com/oauth/request_token", httpMethod: .POST, params: nil, auth: nil)
    
    func requestAuthToken() async throws -> Bool{
        oauth?.signEndPoint(endPoint: &requestTokenEP)
        guard let request = requestTokenEP.networkRequest() else {
            print("Couldn't Construct Network Request")
            return false
        }
        do{
            let (data, _) = try await URLSession.shared.data(for: request)
            guard let oAuthResponse: OAuthResponseString = String(data: data, encoding: .utf8) else {
                print("Unable to read auth response")
                return false
            }
            print(oAuthResponse)
            oauth?.collectAuthToken(authResponse: oAuthResponse)
            return true
        }catch{
            print("Unable to process request. \(error)")
            return false
        }
    }
    
    init(oauth: OAuth) {
        self.oauth = oauth
    }
}
