//
//  TwitterObjects.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 10/06/2022.
//

import Foundation
import UIKit
//MARK: - Twitter User Data
struct TwitterUser: Codable {
    let data:TwitterUserData
}

struct TwitterUserData: Codable {
    let id: String
    let name: String
    let username:String
    let description:String?
    let profile_image_url:String?
    let location: String?
    let verified:Bool
    let protected:Bool
    let url:String?
}

//MARK: - Tweets and Timeline Data
struct Tweet: Codable {
    let data:TweetData?
}

struct Timeline: Codable {
    let data:[TweetData]
    var includes:IncludedData
    let meta:Meta?
}

struct IncludedData: Codable {
    var tweets:[TweetData]?
    var users:[TwitterUserData]
    let media:[MediaElement]?
}

struct MediaElement: Codable {
    let media_key:String
    let type:String
    let url:String?
    let preview_image_url:String?
}

struct Meta: Codable {
    let result_count: Int
    let newest_id: String
    let oldest_id: String
    let next_token: String?
}

struct TweetMetrics: Codable {
    let retweet_count: Int
    let reply_count: Int
    let like_count: Int
    let quote_count: Int
}

struct Attachments: Codable {
    let media_keys: [String]
}

struct TweetData: Codable{
    let id: String
    let author_id: String?
    let text: String
    let lang: String
    let public_metrics:TweetMetrics
    let attachments: Attachments?
    let referenced_tweets: [ReferncedTweet]?
}

struct ReferncedTweet:Codable {
    let type: String
    let id:String
}

struct ProfileHeader:Codable {
    let size600x200: TwitterHeaderImage
    
    enum CodingKeys:String,CodingKey{
        case size600x200 = "600x200"
    }
}

struct TwitterHeaderImage:Codable {
    let h:Int
    let w:Int
    let url:String
}

