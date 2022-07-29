//
//  TimelineViewModel.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 24/06/2022.
//

import UIKit

class TimelineViewModel {
    let handler: TwitterHandler
    var timeline: Timeline?
    
    weak var delegate: ViewModelDelegate? = nil
    var includedTweetsWithQuotesIDs = String()
    var tweetModels = [TweetViewModel](){
        didSet{
            delegate?.didUpdateDataModel()
        }
    }
    
    init(handler:TwitterHandler) {
        self.handler = handler
    }
    
    fileprivate func presentAlert(with statusCode:Int) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "ERROR \(statusCode)", message: "Return To Home Screen", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Return", style: .default, handler: { action in
                self.returnToHomeScreen()
            }))
            self.delegate?.present(alert, animated: true)
        }
    }
    
    fileprivate func returnToHomeScreen(){
        DispatchQueue.main.async {
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! AuthViewController
            self.delegate?.navigationController?.setViewControllers([loginVC], animated: true)
            self.delegate?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func getTimeline(){

        Task.init {
            var userResponse: (TwitterUser?,Int) = (nil, 0)
            do {
                userResponse = try await handler.fetchMyUser()
            } catch{
                print(error)
            }

            print("Got User Data")
            guard userResponse.1 == 200 else {
                presentAlert(with: userResponse.1)
                return
            }
            guard let user = userResponse.0 else {return}
            guard var model = try await handler.getCurrentUserTimeline(currentUserID: user.data.id).0 else {return}
            includedTweetsWithQuotesIDs = ""
            guard let includedTweets = model.includes.tweets else {return}
            for tweet in includedTweets {
                if let tweetReference = tweet.referenced_tweets?[0], tweetReference.type == "quoted" {
                    (includedTweetsWithQuotesIDs.isEmpty) ? includedTweetsWithQuotesIDs.append(tweetReference.id) : includedTweetsWithQuotesIDs.append(",\(tweetReference.id)")
                }
            }
            guard let appendedModel = try await handler.getMultipleTweets(ids: includedTweetsWithQuotesIDs).0 else {return}
            let appendedData = appendedModel.data
            let appendedUsers = appendedModel.includes.users
            for tweet in appendedData{
                model.includes.tweets?.append(tweet)
            }
            for user in appendedUsers {
                model.includes.users.append(user)
            }
            getHome(using: model)
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
        let retweetedBy = (isDisplayedTweetRetweeted) ? userData?.name : nil
        
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
        
        let tweetTextAlignment: NSTextAlignment = (tweetData!.lang == "ar") ? .right : .left
        print("lang: \(tweetData!.lang)")
        let tweetModel = TweetViewModel(displayedAuthor: displayedAuthor,
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
                                        isQuotedAuthorPrivate: isQuotedAuthorPrivate,
                                        tweetAlignment: tweetTextAlignment)
        return tweetModel
    }
}
