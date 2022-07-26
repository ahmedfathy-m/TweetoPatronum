//
//  OAuth2.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 13/07/2022.
//

import Foundation
import WebKit

class OAuth2 {
    let clientID: String
    let callbackURL: String
    var oAuthToken: OAuthToken? = nil
    fileprivate var authCode = ""

    init(id: String, callback: String) {
        self.clientID = id
        self.callbackURL = callback
    }

    func authorize(using webView: inout WKWebView){
        let endPoint: OAuth2EndPoint = .authorize(clientID, callbackURL)
        webView.load(endPoint.request)
    }
    
    func getAccessToken() async throws {
        let endPoint: OAuth2EndPoint = .access(clientID, callbackURL, authCode)
        try await handleResponse(endPoint)
    }
    
    func refreshAccessToken() async throws {
        guard let refreshToken = oAuthToken?.refreshToken else {
            fatalError("No Token Found")
        }
        let endPoint: OAuth2EndPoint = .refresh(clientID, refreshToken: refreshToken)
        try await handleResponse(endPoint)
    }
    
    func revokeAccessToken() async throws {
        guard let accessToken = oAuthToken?.accessToken else {
            fatalError("No Token Found")
        }
        let endPoint : OAuth2EndPoint = .revoke(clientID, accessToken: accessToken)
        try await handleResponse(endPoint)
    }
    
    func collectAuthCode(code: String) {
        self.authCode = code
    }
    
    func authorizeRequest(request: inout URLRequest) {
        //Reminder: add check for expiry to trigger refresh Token
        guard let accessToken = oAuthToken?.accessToken else {
            fatalError("No Token Found")
        }
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    }
    
    private func handleResponse(_ endPoint:OAuth2EndPoint) async throws{
        switch endPoint {
        case .revoke:
            let response = try await URLSession.shared.data(for: endPoint.request)
            guard let httpResponse = response.1 as? HTTPURLResponse else {
                fatalError("No Response from Server")
            }
            if httpResponse.statusCode == 200 {
                print(String(data: response.0, encoding: .utf8))
                oAuthToken = nil
            } else {
                fatalError("Error Code:\(httpResponse.statusCode)")
            }
        case .refresh, .access:
            let response = try await URLSession.shared.data(for: endPoint.request)
            guard let httpResponse = response.1 as? HTTPURLResponse else {
                fatalError("No Response from Server")
            }
            if httpResponse.statusCode == 200 {
                oAuthToken = try? JSONDecoder().decode(OAuthToken.self, from: response.0)
                print(oAuthToken?.accessToken)
            } else {
                fatalError("Error Code:\(httpResponse.statusCode)")
            }
        case .authorize: print("Got Called")
        }
        

    }
}

struct OAuthToken: Decodable {
    let tokenType :String
    let validFor:Int
    let accessToken:String
    let scope:String
    let refreshToken:String

    enum CodingKeys:String,CodingKey {
        case tokenType = "token_type"
        case validFor = "expires_in"
        case accessToken = "access_token"
        case scope
        case refreshToken = "refresh_token"
    }
}
