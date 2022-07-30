//
//  OAuth2TokenStruct.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 30/07/2022.
//

import Foundation

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
