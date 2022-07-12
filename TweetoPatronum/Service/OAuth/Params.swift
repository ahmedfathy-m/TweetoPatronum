//
//  Params.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 06/07/2022.
//

import Foundation

//MARK: - Auth Params
typealias AuthParams = [String:String]

extension AuthParams{
    var oAuthHeader:String{
        var joinedString = ""
        for (key,value) in self{
            if let k = key as? String, let v = value as? String{
                (joinedString.isEmpty) ? joinedString.append("\(k)=\(v)") : joinedString.append(",\(k)=\(v)")
            }
        }
        return "OAuth \(joinedString)"
    }
    
    var oAuthBase:String{
        //returns full params joined by &
        var joinedString = ""
        let authKeys = ["oauth_consumer_key","oauth_nonce", "oauth_signature_method","oauth_timestamp","oauth_token","oauth_version"]
            for key in authKeys where self[key] != nil {
                    let appendedText = (joinedString.isEmpty) ? "\(key)=\(self[key]!)" : "&\(key)=\(self[key]!)"
                    joinedString.append(appendedText)
            }
        return joinedString
    }
}

//MARK: - Request Params
typealias RequestParams = [String:Any]

extension RequestParams{
    func getQueryItems()->[URLQueryItem]{
        var queryItems = [URLQueryItem]()
        for (key, value) in self{
            let newQueryItem = URLQueryItem(name: key, value: value as? String)
            queryItems.append(newQueryItem)
        }
    return queryItems
    }
    
    var paramString:String{
        //returns full params joined by &
        var joinedString = ""
        for (key,value) in self{
            if let k = key as? String, let v = value as? String{
                (joinedString.isEmpty) ? joinedString.append("\(k)=\(v)") : joinedString.append("&\(k)=\(v)")
            }
        }
        return joinedString
    }
    
}
