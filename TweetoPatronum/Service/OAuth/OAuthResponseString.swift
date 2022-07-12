//
//  OAuthResponseString.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 07/07/2022.
//

import Foundation

typealias OAuthResponseString = String

extension OAuthResponseString{
    var responseParams: [String: String]? {
        var oauthParameters = [String:String]()
        let oauth = self.split(separator: "&")
        for kvPair in oauth{
            guard let key = kvPair.split(separator: "=").first?.description else {return nil}
            guard let value = kvPair.split(separator: "=").last?.description else {return nil}
            oauthParameters[key] = value
        }
        return oauthParameters
    }
}
