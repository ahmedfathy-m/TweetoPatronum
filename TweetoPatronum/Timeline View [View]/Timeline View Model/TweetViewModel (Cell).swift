//
//  TweetViewModel (Cell).swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 25/06/2022.
//

import Foundation

struct TweetViewModel{
    var displayedAuthor:String?
    var displayedAvatar:String?
    var displayedHandle:String?
    var displayedTweet:String?
    var isDisplayedAuthorVerified:Bool?
    var isDisplayedAuthorPrivate:Bool?
    
    var retweetCount: Int?
    var likeCount:Int?
    var replyCount:Int?
    
    var isDisplayedTweetRetweeted:Bool
    var retweetedBy:String?
    
    var doesContainQuote: Bool
    var quotedAuthor: String?
    var quotedHandle: String?
    var quotedTweet: String?
    var quotedAvatar:String?
    var isQuotedAuthorVerified:Bool?
    var isQuotedAuthorPrivate:Bool?
}
