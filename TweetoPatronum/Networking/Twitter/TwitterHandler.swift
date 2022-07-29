//
//  TwitterModel.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 11/06/2022.
//

import Foundation
import UIKit

class TwitterHandler {
    let oauth: OAuth2
    
    init(_ auth:OAuth2) {
        oauth = auth
    }
    //MARK: - Get User Using ID
    func fetchUser(id:String) async throws -> (TwitterUser?,Int) {
        let endpoint : TwitterEndPoint = .fetchUser(id)
        return try await handleResponse(from: endpoint)
    }
    
    //MARK: - Get Authenticated User
    func fetchMyUser() async throws -> (TwitterUser?,Int) {
        let endPoint : TwitterEndPoint = .fetchMyUser
        return try await handleResponse(from: endPoint)
    }
        
    //MARK: - Get User Timeline Using ID
    func getCurrentUserTimeline(currentUserID: String) async throws -> (Timeline?,Int){
        let endPoint : TwitterEndPoint = .fetchTimeline(currentUserID)
        return try await handleResponse(from: endPoint)
    }
    
    //MARK: - Lookup Tweet/Tweets
    func getMultipleTweets(ids: String...) async throws->(Timeline?,Int){
        let endPoint: TwitterEndPoint = .fetchMultipleTweets(ids.joined(separator: ","))
        return try await handleResponse(from: endPoint)
    }

    //MARK: - Search Tweets
    func search(using query:TwitterQuery) async throws->(Timeline?,Int){
        let endPoint: TwitterEndPoint = .search(query)
        return try await handleResponse(from: endPoint)
    }
    
    //MARK: - Fetch User Tweets
    func fetchUserTweets(using id:String) async throws->(Timeline?,Int){
        let endPoint: TwitterEndPoint = .fetchUserTweets(id)
        return try await handleResponse(from: endPoint)
    }
    
    //MARK: - Fetch User Tweets
    func getUserBanner(using id:String) async throws->(ProfileHeader?,Int){
        //Requires OAuth1.0
        let endPoint: TwitterEndPoint = .fetchUserHeader(id)
        return try await handleResponse(from: endPoint)
    }
    
    
    func handleResponse<T:Codable>(from endPoint:TwitterEndPoint) async throws->(T?,statusCode: Int){
        print("I tried")
        var data: T? = nil
        var request = endPoint.request
        try await oauth.authorizeRequest(request: &request)
        let response = try await URLSession.shared.data(for: request)
        guard let httpResponse = response.1 as? HTTPURLResponse else {
            fatalError("No Response from Server")
        }
        if httpResponse.statusCode == 200 {
            do {
                data = try JSONDecoder().decode(T.self, from: response.0)
            }catch{
                print(error)
            }
        } else {
//            fatalError("Error Code:\(httpResponse.statusCode)")
        }
        return (data,httpResponse.statusCode)
    }
}

