//
//  OAuth2EndPoints.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 22/07/2022.
//

import Foundation
enum OAuth2EndPoint {
    private var baseURL: String{
        return "https://api.twitter.com/2/oauth2"
    }
    
    case authorize(_ clientID: String,_ callbackURL:String)
    case access(_ clientID:String,_ callbackURL:String,_ code:String)
    case refresh(_ clientID:String,refreshToken:String)
    case revoke(_ clientID:String,accessToken:String)
    
    private var targetURL: URLComponents? {
        switch self {
        case .authorize:
            return URLComponents(string: "https://twitter.com/i/oauth2/authorize")
        case .access:
            return URLComponents(string: baseURL + "/token")
        case .refresh:
            return URLComponents(string: baseURL + "/token")
        case .revoke:
            return URLComponents(string: baseURL + "/revoke")
        }
    }
    
    private var queryParam: [String:Any] {
        switch self {
        case .authorize(let clientID, let callbackURL):
            return ["response_type":"code",
                    "client_id":clientID,
                    "redirect_uri":callbackURL,
                    "scope":"tweet.read users.read follows.read offline.access",
                    "state":"state",
                    "code_challenge":"challenge",
                    "code_challenge_method":"plain"]
        case .access:
            return [:]
        case .refresh:
            return [:]
        case .revoke:
            return [:]
        }
    }
    
    private var headerParams: [String:String]{
        switch self {
        case .authorize:
            return [:]
        case .access:
            return ["Content-Type":"application/x-www-form-urlencoded"]
        case .refresh:
            return ["Content-Type":"application/x-www-form-urlencoded"]
        case .revoke:
            return ["Content-Type":"application/x-www-form-urlencoded"]
        }
    }
    
    private var bodyParams: [String:String]{
        switch self {
        case .authorize:
            return [:]
        case .access(let clientID, let callbackURL, let code):
            return ["code":code,
                    "grant_type":"authorization_code",
                    "client_id":clientID,
                    "redirect_uri":callbackURL,
                    "code_verifier":"challenge"]
        case .refresh(let clientID, let refreshToken):
            return ["refresh_token":refreshToken,
                    "grant_type":"refresh_token",
                    "client_id":clientID]
        case .revoke(let clientID, let accessToken):
            return ["token":accessToken,
                    "client_id":clientID]
        }
    }
    var request: URLRequest{
        switch self {
        case .authorize:
            return createRequest(targetURL, method: .GET, query: queryParam)
        case .access:
            return createRequest(targetURL, method: .POST, headerParams, bodyParams)
        case .refresh:
            return createRequest(targetURL, method: .POST, headerParams, bodyParams)
        case .revoke:
            return createRequest(targetURL, method: .POST, headerParams, bodyParams)
        }
    }
    
    private func createRequest(_ targetURL: URLComponents?, method:HTTPMethod, _ header: [String:String] = [:],query queryParams: [String:Any] = [:],_ bodyParams: [String:String] = [:]) -> URLRequest{
        //Building the URL
        guard var targetURL = targetURL else {
            fatalError("Couldn't Unwrap URL with components")
        }
        var queryItems = [URLQueryItem]()
        queryParams.forEach { (key: String, value: Any) in
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            queryItems.append(queryItem)
        }
        targetURL.queryItems = queryItems
        
        guard let url = targetURL.url else {
            fatalError("Couldn't Build Final URL")
        }
        
        //Creating the Request
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        request.httpMethod = method.rawValue
        
        //AddingTheBody
        if method == .POST {
            var dataString = ""
            bodyParams.forEach { (key: String, value: String) in
                dataString.isEmpty ? dataString.append("\(key)=\(value)") : dataString.append("&\(key)=\(value)")
            }
            request.httpBody = dataString.data(using: .utf8)
        }
        return request
    }
}
