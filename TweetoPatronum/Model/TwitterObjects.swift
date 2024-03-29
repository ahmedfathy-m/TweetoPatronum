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
    let authorID: String?
    let text: String
    let lang: String
    let publicMetrics:TweetMetrics
    let attachments: Attachments?
    let referencedTweets: [ReferncedTweet]?
    let entities: Entities?
    
    var computedText: NSMutableAttributedString{
        let attributedText:NSMutableAttributedString = NSMutableAttributedString(string: text)
        if let urls = entities?.urls {
            urls.forEach { url in
                if attributedText.mutableString.contains(url.url) {
                    let range = (attributedText.mutableString as NSString).range(of: url.url)
                    attributedText.addAttribute(.link, value: url.expanded_url, range: range)
                    attributedText.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range)
                    attributedText.replaceCharacters(in: range, with: url.expanded_url)
                }
            }
        }
        
        if let mentions = entities?.mentions{
            mentions.forEach { mention in
                let range = (attributedText.mutableString as NSString).range(of: "@\(mention.username)")
                attributedText.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range)
            }
        }
        
        if let hashtags = entities?.hashtags{
            hashtags.forEach { hashtag in
                let range = (attributedText.mutableString as NSString).range(of: "#\(hashtag.tag)")
                attributedText.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range)
            }
        }
        return attributedText
    }
    
    enum CodingKeys:String,CodingKey{
        case id,text,lang,attachments,entities
        case publicMetrics = "public_metrics"
        case referencedTweets = "referenced_tweets"
        case authorID = "author_id"
    }
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

struct Entities: Codable {
    let urls: [URLEntitiy]?
    let mentions: [MentionEntity]?
    let hashtags: [HashTagEntity]?
}

struct URLEntitiy: Codable{
    let start:Int
    let end:Int
    let url:String
    let expanded_url:String
    let display_url:String
    let unwound_url:String?
    
    var length: Int{
        return end - start
    }
    
    enum CodingKeys:String,CodingKey{
        case start,end,url,expanded_url,display_url,unwound_url
    }
}

struct MentionEntity: Codable{
    let start:Int
    let end:Int
    let username:String
    
    var length: Int{
        return end - start
    }
    enum CodingKeys:String,CodingKey{
        case start,end,username
    }
}

struct HashTagEntity: Codable{
    let start:Int
    let end:Int
    let tag:String
}

