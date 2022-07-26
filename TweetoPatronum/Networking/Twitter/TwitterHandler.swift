//
//  TwitterModel.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 11/06/2022.
//

import Foundation

class TwitterHandler {
    let oauth: OAuth2
    
    init(_ auth:OAuth2) {
        oauth = auth
    }
    //MARK: - Get User Using ID
    func fetchUser(id:String) async throws -> TwitterUser {
        let endpoint : TwitterEndPoint = .fetchUser(id)
        return try await handleResponse(from: endpoint)
    }
    
    func fetchMyUser() async throws -> TwitterUser {
        let endPoint : TwitterEndPoint = .fetchMyUser
        print("MyUser")
        return try await handleResponse(from: endPoint)
    }
        
    //MARK: - Get User Timeline Using ID
    
    func getCurrentUserTimeline(currentUserID: String) async throws -> Timeline{
        let endPoint : TwitterEndPoint = .fetchTimeline(currentUserID)
        print("MyTime")
        return try await handleResponse(from: endPoint)
    }
    
    func getMultipleTweets(ids: String...) async throws->Timeline{
        let endPoint: TwitterEndPoint = .fetchMultipleTweets(ids.joined(separator: ","))
        return try await handleResponse(from: endPoint)
    }
    
    func handleResponse<T:Codable>(from endPoint:TwitterEndPoint) async throws->T{
        var data: T? = nil
        var request = endPoint.request
        oauth.authorizeRequest(request: &request)
        let response = try await URLSession.shared.data(for: request)
        guard let httpResponse = response.1 as? HTTPURLResponse else {
            fatalError("No Response from Server")
        }
        print(httpResponse.statusCode)
        if httpResponse.statusCode == 200 {
            do {
                data = try JSONDecoder().decode(T.self, from: response.0)
            }catch{
                print(error)
            }
        } else {
            fatalError("Error Code:\(httpResponse.statusCode)")
        }
        return data!
    }
}

