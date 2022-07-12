//
//  TwitterModel.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 11/06/2022.
//

import Foundation
import UIKit

class TwitterHandler {
    var oauth: OAuth?
    
    init(oauth: OAuth) {
        self.oauth = oauth
    }
    
    
    //MARK: - Get User Using ID
    func fetchUser(id:String) async throws -> TwitterUser?{
        var endPoint = userDataEndPoint(using: id)
        oauth?.signEndPoint(endPoint: &endPoint)
        guard let request = endPoint.networkRequest() else {
            print("Couldn't construct network request")
            return nil
        }
        let (data,_) = try await URLSession.shared.data(for: request)
        do{
            let user = try JSONDecoder().decode(TwitterUser.self, from: data)
            return user
        }catch{
            print(error)
            return nil
        }
    }
        
    //MARK: - Get User Timeline Using ID
    
    func getCurrentUserTimeline() async throws -> Timeline?{
        guard var endPoint = timelineEndPoint() else {
            return nil
        }
        oauth?.signEndPoint(endPoint: &endPoint)
        guard let request = endPoint.networkRequest() else {
            print("Couldn't construct network request")
            return nil
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {return nil}
        let timeline = try JSONDecoder().decode(Timeline.self, from: data)
        return timeline
    }
    
    func getMultipleTweets(ids: String...) async throws->Timeline?{
        guard var endPoint = getTweetsEndPoint(ids: ids) else{
            return nil
        }
        oauth?.signEndPoint(endPoint: &endPoint)
        guard let request = endPoint.networkRequest() else {
            print("Couldn't construct network request")
            return nil
        }
        let (data,_) = try await URLSession.shared.data(for: request)
        let timeline = try JSONDecoder().decode(Timeline.self, from: data)
        return timeline
    }
}

