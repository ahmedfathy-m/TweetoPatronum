//
//  TwitterSearchQuery.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 27/07/2022.
//

import Foundation

enum TwitterQuery {
    case someUserTweets(_ id:String)
    case someUserRetweets(_ id:String)
    case someUserMedia(_ id:String)
    
    var searchQuery: String{
        switch self {
        case .someUserTweets(let id):
            return "from:\(id)"
        case .someUserRetweets(let id):
            return "from:\(id) AND is:retweet"
        case .someUserMedia(let id):
            return "from:\(id) AND has:media"
        }
    }
}
