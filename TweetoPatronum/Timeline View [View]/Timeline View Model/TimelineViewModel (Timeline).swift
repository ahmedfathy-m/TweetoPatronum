//
//  TimelineViewModel.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 24/06/2022.
//

import Foundation
import UIKit

class TimelineViewModel {
    var oauth:OAuth
    lazy var handler = {
        TwitterHandler(oauth: self.oauth)
    }()
    var timeline: Timeline?
    var includedTweetsWithQuotesIDs = String()
    var reloadTableView: (() -> Void)?
    var tweetModels = [TweetViewModel](){
        didSet{
            reloadTableView?()
        }
    }
    
    init(oauth:OAuth) {
        self.oauth = oauth
    }
    
    func getTimeline(){
        Task.init {
            do{
//                var model = try await TwitterHandler.getUserTimelineWithID(id:"1425224156426162177",token:Keys.currentToken)
                var model = try await handler.getCurrentUserTimeline()
                includedTweetsWithQuotesIDs = ""
                guard let includedTweets = model?.includes.tweets else {return}
                for tweet in includedTweets {
                    if let tweetReference = tweet.referenced_tweets?[0], tweetReference.type == "quoted" {
                        (includedTweetsWithQuotesIDs.isEmpty) ? includedTweetsWithQuotesIDs.append(tweetReference.id) : includedTweetsWithQuotesIDs.append(",\(tweetReference.id)")
                    }
                }
                
//                let appendedModel = try await TwitterHandler.getTweets(ids: includedTweetsWithQuotesIDs, token: Keys.currentToken)
                let appendedModel = try await handler.getMultipleTweets(ids: includedTweetsWithQuotesIDs)
                guard let appendedData = appendedModel?.data else { return }
                guard let appendedUsers = appendedModel?.includes.users else { return  }
                for tweet in appendedData{
                    model?.includes.tweets?.append(tweet)
                }
                for user in appendedUsers {
                    model?.includes.users.append(user)
                }
                
                getHome(using: model)
            }catch{
                print(error)
            }
        }
    }
    
    func getHome(using timeline:Timeline?){
        self.timeline = timeline
        var tModels = [TweetViewModel]()
        if let tweets = timeline?.data{
            for tweet in tweets{
                tModels.append(createTweetModel(from: timeline, for: tweet))
            }
            tweetModels = tModels
        }
    }
    
    func getTweetModel(at index: IndexPath) -> TweetViewModel{
        return tweetModels[index.row]
    }
    
    enum TweetReference: String {
        case retweeted = "retweeted"
        case quoted = "quoted"
        case replied = "replied_to"
    }
    
    func createTweetModel(from timeline:Timeline?, for tweet: TweetData?)-> TweetViewModel{
        let tweetData = tweet
        //get UserData with 'author_id'
        let userData = timeline?.includes.users.first(where: {$0.id == tweetData?.author_id})
        
        var isDisplayedTweetRetweeted  = false //Default Value
        var doesContainQuote = false //Default Value
        
        let tweetReference = tweetData?.referenced_tweets?[0]
        let includedTweet = timeline?.includes.tweets?.first(where: {$0.id == tweetReference?.id})
        let includedTweetAuthor = timeline?.includes.users.first(where: {$0.id == includedTweet?.author_id})
        
        //Check for tweet refernce type (Retweeted, Quoted, None)
        if (tweetReference != nil){
            if tweetReference?.type == "retweeted" {
                isDisplayedTweetRetweeted = true
                if (includedTweet != nil),(includedTweet?.referenced_tweets?[0].type == "quoted"){
                    doesContainQuote = true
                }else{
                    doesContainQuote = false
                }
            }else if tweetReference?.type == "quoted" {
                isDisplayedTweetRetweeted = false
                doesContainQuote = true
            }
        }else{
            isDisplayedTweetRetweeted = false
            doesContainQuote = false
        }
        
        
        let displayedAuthor = (isDisplayedTweetRetweeted) ? includedTweetAuthor?.name : userData?.name
        let displayedHandle = (isDisplayedTweetRetweeted) ? "@\(includedTweetAuthor?.username ?? "*ERROR*")" : "@\(userData?.username ?? "*ERROR*")"
        let displayedAvatar = (isDisplayedTweetRetweeted) ? includedTweetAuthor?.profile_image_url : userData?.profile_image_url
        let displayedTweet = (isDisplayedTweetRetweeted) ? includedTweet?.text : tweetData?.text
        let isDisplayedAuthorVerified = (isDisplayedTweetRetweeted) ? includedTweetAuthor?.verified : userData?.verified
        let isDisplayedAuthorPrivate = (isDisplayedTweetRetweeted) ? includedTweetAuthor?.protected : userData?.protected
        let retweetedBy = (isDisplayedTweetRetweeted) ? includedTweetAuthor?.name : nil
        
        let retweetCount = tweetData?.public_metrics.retweet_count
        let likeCount = tweetData?.public_metrics.like_count
        let replyCount = tweetData?.public_metrics.reply_count
        
        let quotedTweet: TweetData?
        let quotedUser:TwitterUserData?
        if (tweetReference?.type == "retweeted"),(includedTweet?.referenced_tweets?[0].type == "quoted"){
            quotedTweet = timeline?.includes.tweets?.first(where: {$0.id == includedTweet?.referenced_tweets?[0].id})
            quotedUser = timeline?.includes.users.first(where: {$0.id == quotedTweet?.author_id})
        }else if (tweetReference?.type == "quoted") {
            quotedTweet = timeline?.includes.tweets?.first(where: {$0.id == tweetReference?.id})
            quotedUser = timeline?.includes.users.first(where: {$0.id == quotedTweet?.author_id})
        }else{
            quotedTweet = nil
            quotedUser = nil
        }
        let quotedAuthor = (doesContainQuote) ? quotedUser?.name : nil
        let quotedHandle = (doesContainQuote) ? "@\(quotedUser?.username ?? "*ERROR*")" : nil
        let quotedAvatar = (doesContainQuote) ? quotedUser?.profile_image_url : nil
        let quotedTweetText = (doesContainQuote) ? quotedTweet?.text : nil
        let isQuotedAuthorVerified = (doesContainQuote) ? quotedUser?.verified : false
        let isQuotedAuthorPrivate = (doesContainQuote) ? quotedUser?.protected : false
        
        let TweetModel = TweetViewModel(displayedAuthor: displayedAuthor,
                                        displayedAvatar: displayedAvatar,
                                        displayedHandle: displayedHandle,
                                        displayedTweet: displayedTweet,
                                        isDisplayedAuthorVerified: isDisplayedAuthorVerified,
                                        isDisplayedAuthorPrivate: isDisplayedAuthorPrivate,
                                        retweetCount: retweetCount,
                                        likeCount: likeCount,
                                        replyCount: replyCount,
                                        isDisplayedTweetRetweeted: isDisplayedTweetRetweeted,
                                        retweetedBy: retweetedBy,
                                        doesContainQuote: doesContainQuote,
                                        quotedAuthor: quotedAuthor,
                                        quotedHandle: quotedHandle,
                                        quotedTweet: quotedTweetText,
                                        quotedAvatar: quotedAvatar,
                                        isQuotedAuthorVerified: isQuotedAuthorVerified,
                                        isQuotedAuthorPrivate: isQuotedAuthorPrivate)
        return TweetModel
    }
}
