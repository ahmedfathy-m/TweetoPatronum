//
//  TwitterEndPoints.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 09/07/2022.
//

import Foundation

extension TwitterHandler{
    func userDataEndPoint(using id:String) -> EndPoint{
        let baseURL = "https://api.twitter.com/2/users/\(id)"
        let httpMethod: HTTPMethod = .GET
        let params:RequestParams = ["user.fields":"created_at,location,profile_image_url,url,verified,description"]
        return EndPoint(baseURL: baseURL, httpMethod: httpMethod, params: params, auth: nil)
    }
    
    func timelineEndPoint()-> EndPoint?{
        guard let currentID = oauth?.currentUserID else {
            print("User ID isn't available. can't build request")
            return nil
        }
        let baseURL = "https://api.twitter.com/2/users/\(currentID)/timelines/reverse_chronological"
        let httpMethod: HTTPMethod = .GET
        let params: RequestParams = ["expansions":"author_id,attachments.media_keys,referenced_tweets.id.author_id,referenced_tweets.id",
                                     "tweet.fields":"public_metrics,referenced_tweets",
                                     "user.fields":"profile_image_url,verified,protected",
                                     "media.fields":"preview_image_url,url"]
        return EndPoint(baseURL: baseURL, httpMethod: httpMethod, params: params, auth: nil)
    }
    
    func getTweetsEndPoint(ids: [String])-> EndPoint?{
        var idParam = String()
        for id in ids {
            (idParam.isEmpty) ? idParam.append(id) : idParam.append(",\(id)")
        }
        let baseURL = "https://api.twitter.com/2/tweets"
        let httpMethod: HTTPMethod = .GET
        let params: RequestParams = ["ids":idParam,
                                     "expansions":"author_id,attachments.media_keys,referenced_tweets.id.author_id,referenced_tweets.id",
                                     "tweet.fields":"public_metrics,referenced_tweets",
                                     "user.fields":"profile_image_url,verified,protected",
                                     "media.fields":"preview_image_url,url"]
        return EndPoint(baseURL: baseURL, httpMethod: httpMethod, params: params, auth: nil)
    }
    
    func currentUserEndPoint() -> EndPoint{
        let baseURL = "https://api.twitter.com/2/users/me"
        let httpMethod: HTTPMethod = .GET
        let params: RequestParams = ["user.fields":"created_at,location,profile_image_url,url,verified,description"]
        return EndPoint(baseURL: baseURL, httpMethod: httpMethod, params: params, auth: nil)
    }
}
