//
//  OAuth.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 24/06/2022.
//

import Foundation
import Crypto
import SwiftCrypto


class OAuth {
    let consumerKey = Keys.apiKey
    private let consumerSecret = Keys.secretKey
    private let oauthSignatureMethod = "HMAC-SHA1"
    private let OAuthTimeStamp = NSTimeIntervalSince1970
    private let oauthVersion = "1.0"
    private var secretToken = ""
    var oauthToken = ""
    var oauthVerifier = ""
    var accessToken:String? = nil
    var accessTokenSecret = ""
    var currentUserID = ""
    private var currentUserHandle = ""
       
    func signEndPoint(endPoint: inout EndPoint){
        let nonce = self.genNonce()
        var signKey = "\(consumerSecret)&\(accessTokenSecret)"
        var authParams: AuthParams = ["oauth_consumer_key":consumerKey,
                                      "oauth_nonce": nonce,
                                      "oauth_signature_method":oauthSignatureMethod,
                                      "oauth_timestamp":String(Int64(Date().timeIntervalSince1970)),
                                      "oauth_version":oauthVersion]
        if (accessToken != nil) {
            authParams["oauth_token"] = accessToken
        }
        endPoint.auth = authParams
        let allowedChars = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._-~")
        guard let baseString = endPoint.generateBaseString() else { return }
        let hmac = baseString.digest(.sha1, key: signKey).hexDataFromString()
        let base64Signature = hmac?.base64EncodedString()
        let encodedSignature = base64Signature?.addingPercentEncoding(withAllowedCharacters: allowedChars)
        endPoint.auth?["oauth_signature"] = encodedSignature
    }
    

    
    func collectVerifier(verifier: String){
        oauthVerifier = verifier
    }
    
    func collectAuthToken(authResponse: OAuthResponseString){
        guard let authResponseParams = authResponse.responseParams else {
            print("Unable to fetch oauth_token and oauth_token_secret")
            return
        }
        secretToken = authResponseParams["oauth_token_secret"] ?? ""
        oauthToken = authResponseParams["oauth_token"] ?? ""
    }
    
    func collectAccessToken(accessResponse: OAuthResponseString){
        guard let accessResponseParams = accessResponse.responseParams else {
            print("Unable to fetch accessToken")
            return
        }
        accessToken = accessResponseParams["oauth_token"] ?? ""
        accessTokenSecret = accessResponseParams["oauth_token_secret"] ?? ""
        currentUserID = accessResponseParams["user_id"] ?? ""
        currentUserHandle = accessResponseParams["screen_name"] ?? ""
    }
    
    private func genNonce() -> String{
        let uuidString: String = UUID().uuidString
        return uuidString[0..<8]
    }
}
