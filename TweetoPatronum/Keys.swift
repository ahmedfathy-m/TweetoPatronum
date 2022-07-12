//
//  Keys.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 10/06/2022.
//

import Foundation

struct Keys {
    static let apiKey = ""
    static let secretKey = ""
    static let bearerToken = "AAAAAAAAAAAAAAAAAAAAAJLOdQEAAAAA9Oiph4Zpq0DS1Np%2FV%2FdablcXGa8%3D6O2Huwt6ZIHMDhONvowrTfYPPQ6h6rbuJqXqgLzDNvYRPxy0Ty"
    static let currentToken = "X1RwQTQxVDh2Q2lTMV9NdUEzOVptWGhoV0hfaVhWZlhraW5jZWpLTjI2bjRwOjE2NTYzNjMxNDU0NjI6MTowOmF0OjE"
}

struct Requests {
    static let timelineRequest = "https://api.twitter.com/2/users/1425224156426162177/timelines/reverse_chronological?tweet.fields=author_id%2Ccreated_at&user.fields=name"
}

enum TweetCodingKeys: String, CodingKey {
    case id
    case authorID = "author_id"
    case text
    case postTime = "created_at"
    case referencedTweets = "referenced_tweets"
}
