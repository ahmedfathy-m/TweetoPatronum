//
//  +(Dictionary).swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 27/06/2022.
//

import Foundation

extension Dictionary{
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
    
    var authHeaderBase:String{
        //returns full params joined by &
        var joinedString = ""
        let authKeys = ["oauth_consumer_key","oauth_nonce", "oauth_signature_method","oauth_timestamp","oauth_version"]
      
            for key in authKeys {
                if let k = key as? Key, let v = self[k] as? String {
                    let appendedText = (joinedString.isEmpty) ? "\(k)=\(v)" : "&\(k)=\(v)"
                    joinedString.append(appendedText)
                }
            }
        return joinedString
    }
    
    var authHeader:String{
        var joinedString = ""
        for (key,value) in self{
            if let k = key as? String, let v = value as? String{
                (joinedString.isEmpty) ? joinedString.append("\(k)=\(v)") : joinedString.append(",\(k)=\(v)")
            }
        }
        return joinedString
    }
}
