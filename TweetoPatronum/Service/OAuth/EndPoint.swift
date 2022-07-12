//
//  OAuthRequest.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 01/07/2022.
//

import Foundation



enum HTTPMethod: String{
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
}

struct EndPoint{
    var baseURL: String
    let httpMethod:HTTPMethod
    var params:RequestParams?
    var auth:AuthParams?
    
    func networkRequest()->URLRequest?{
                var requestURL = URLComponents(string: baseURL)
                requestURL?.queryItems = params?.getQueryItems()
                print(requestURL?.query)
                guard let newURL = requestURL?.url else {
                    print("Error Adding Parameters to URL. Couldn't Create Request.")
                    return nil
                }
        var request = URLRequest(url: newURL)
        request.httpMethod = httpMethod.rawValue
        request.setValue((auth?.oAuthHeader) ?? "", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func generateBaseString()->String?{
        let allowedChars = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._-~")
        var fullParams = [String:String]()
        if let params = params as? [String:String] {
            fullParams.merge(params) { current, _ in current }
        }
        if let auth = auth {
            fullParams.merge(auth) { current, _ in current }
        }
        
        var parameterString = ""
        print(fullParams.keys.sorted())
        for key in fullParams.keys.sorted() where fullParams[key] != nil {
            let value = fullParams[key]!.addingPercentEncoding(withAllowedCharacters: allowedChars)!
            (parameterString.isEmpty) ? parameterString.append("\(key)=\(value)") : parameterString.append("&\(key)=\(value)")
        }
        guard let encodedParamString = parameterString.addingPercentEncoding(withAllowedCharacters: allowedChars) else { return nil }
        guard let encodedEndPoint = baseURL.addingPercentEncoding(withAllowedCharacters: allowedChars) else { return nil }
        let baseString = "\(httpMethod.rawValue)&\(encodedEndPoint)&\(encodedParamString)"
        print(baseString)
        return baseString
    }
}
