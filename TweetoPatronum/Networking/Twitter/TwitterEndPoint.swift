//
//  TwitterEndPoint.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 22/07/2022.
//

import Foundation

enum TwitterEndPoint {
    private var baseURL:String {
        return "https://api.twitter.com/2"
    }
    case fetchUser(_ id:String)
    case fetchMyUser
    case fetchTweet(_ id:String)
    case fetchMultipleTweets(_ ids:String)
    case fetchTimeline(_ id:String)
    case search(_ query: TwitterQuery)
    case fetchUserTweets(_ id:String)
    case fetchUserHeader(_ id:String)
    case fetchUserMentions(_ id:String)
    
    private var targetURL:URLComponents? {
        switch self {
        case .fetchUser(let id):
            return URLComponents(string: "\(baseURL)/users/\(id)")
        case .fetchMyUser:
            return URLComponents(string: "\(baseURL)/users/me")
        case .fetchTweet(let id):
            return URLComponents(string: "\(baseURL)/tweets/\(id)")
        case .fetchTimeline(let id):
            return URLComponents (string: "\(baseURL)/users/\(id)/timelines/reverse_chronological")
        case .fetchMultipleTweets(let ids):
            return URLComponents(string: "\(baseURL)/tweets?ids=\(ids)")
        case .search:
            return URLComponents(string: "\(baseURL)/tweets/search/recent")
        case .fetchUserTweets(let id):
            return URLComponents(string: "\(baseURL)/users/\(id)/tweets")
        case .fetchUserHeader:
            return URLComponents(string: "https://api.twitter.com/1.1/users/profile_banner.json")
        case .fetchUserMentions(let id):
            return URLComponents(string: "\(baseURL)/users/\(id)/mentions")
        }
    }
    
    private var query:[String:Any] {
        switch self {
        case .fetchUser:
            return userParams
        case .fetchMyUser:
            return userParams
        case .fetchTweet:
            return multiTweetParams
        case .fetchMultipleTweets:
            return multiTweetParams
        case .fetchTimeline:
            return multiTweetParams
        case .search(let query):
            var searchParam = multiTweetParams
            searchParam["query"] = query.searchQuery
            return searchParam
        case .fetchUserTweets(_):
            var userTweetParam = multiTweetParams
            userTweetParam["exclude"] = "replies"
            return userTweetParam
        case .fetchUserMentions:
            return multiTweetParams
        case .fetchUserHeader(let id):
            return ["user_id":id]
        }
    }
    
    private var header:[String:String] {
        return [:]
    }
    
    private var bodyParams: [String:String] {
        return [:]
    }
    
    var request: URLRequest {
        return createRequest(targetURL, method: .GET, queryParams: query)
    }
    
    private func createRequest(_ targetURL: URLComponents?, method:HTTPMethod, _ header: [String:String] = [:],queryParams: [String:Any] = [:],_ bodyParams: [String:String] = [:]) -> URLRequest{
        //Building the URL
        guard var targetURL = targetURL else {
            fatalError("Couldn't Unwrap URL with components")
        }
        var queryItems : [URLQueryItem] = targetURL.queryItems ?? [URLQueryItem]()
        queryParams.forEach { (key: String, value: Any) in
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            queryItems.append(queryItem)
        }
        targetURL.queryItems = queryItems
        
        guard let url = targetURL.url else {
            fatalError("Couldn't Build Final URL")
        }
        
        //Creating the Request
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        request.httpMethod = method.rawValue
        
        //AddingTheBody
        if method == .POST {
            var dataString = ""
            bodyParams.forEach { (key: String, value: String) in
                dataString.isEmpty ? dataString.append("\(key)=\(value)") : dataString.append("&\(key)=\(value)")
            }
            request.httpBody = dataString.data(using: .utf8)
        }
        return request
    }
}

extension TwitterEndPoint {
    private var multiTweetParams: [String:Any] {
        return ["expansions":"author_id,attachments.media_keys,referenced_tweets.id.author_id,referenced_tweets.id",
                "tweet.fields":"public_metrics,referenced_tweets,lang,entities",
                "user.fields":"profile_image_url,verified,protected",
                "media.fields":"preview_image_url,url"]
    }
    
    private var userParams: [String: Any] {
        return ["user.fields":"location,profile_image_url,url,verified,protected,description"]
    }
}
