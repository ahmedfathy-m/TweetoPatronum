//
//  TimelineViewModel.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 24/06/2022.
//

import UIKit

class TimelineViewModel {
    let handler: TwitterHandler
    private var timeline: Timeline?{
        didSet{
            delegate?.didUpdateDataModel()
        }
    }
    
    var tweetCount:Int? {
        return timeline?.data.count
    }
    
    weak var delegate: ViewModelDelegate? = nil
    
    private var includedTweetsWithQuotesIDs = String()
    
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
            
            guard userResponse.1 == 200 else {
                presentAlert(with: userResponse.1)
                return
            }
            handler.userID = (userResponse.0?.data.id)!
            guard let user = userResponse.0 else {return}
            
            guard var model = try await handler.getCurrentUserTimeline(currentUserID: user.data.id).0 else {return}
            
            includedTweetsWithQuotesIDs = ""
            var includedTweetsWithQuotes = [String]()
            
            
            guard let includedTweets = model.includes.tweets else {return}
            for tweet in includedTweets where tweet.referenced_tweets?[0].type == "quoted" {
                    includedTweetsWithQuotes.append(tweet.referenced_tweets![0].id)
            }
            
            includedTweetsWithQuotesIDs = includedTweetsWithQuotes.joined(separator: ",")
            
            guard let appendedModel = try await handler.getMultipleTweets(ids: includedTweetsWithQuotesIDs).0 else {return}
            
            let appendedData = appendedModel.data
            let appendedUsers = appendedModel.includes.users
            
            for tweet in appendedData{
                model.includes.tweets?.append(tweet)
            }
            for user in appendedUsers {
                model.includes.users.append(user)
            }
            
            timeline = model
        }
    }
    
    enum TweetReference: String {
        case retweeted = "retweeted"
        case quoted = "quoted"
        case replied = "replied_to"
    }
    
    func configureCell(_ cell: TweetElementCell, at indexPath:IndexPath){
        guard let tweetAtIndexPath = timeline?.data[indexPath.row] else {return}
        let reference = tweetAtIndexPath.referenced_tweets?[0].type
        switch reference{
        case "quoted":
            if let authorOfTweetAtIndexPath = timeline?.includes.users.first(where: {$0.id == tweetAtIndexPath.author_id}) {
                cell.authorName.text = authorOfTweetAtIndexPath.name
                cell.authorHandle.text = "@\(authorOfTweetAtIndexPath.username)"
                cell.isAuthorVerified.isHidden = !(authorOfTweetAtIndexPath.verified)
                cell.isAuthorPrivate.isHidden = !(authorOfTweetAtIndexPath.protected)
                cell.retweetedByLabel.isHidden = true
                cell.tweetText.text = tweetAtIndexPath.text
                cell.retweetButton.setTitle(tweetAtIndexPath.public_metrics.retweet_count.kFormattedString, for: .normal)
                cell.likeButton.setTitle(tweetAtIndexPath.public_metrics.like_count.kFormattedString, for: .normal)
                cell.replyButton.setTitle(tweetAtIndexPath.public_metrics.reply_count.kFormattedString, for: .normal)
                cell.authorAvi.downloadImage(from: authorOfTweetAtIndexPath.profile_image_url!)
                cell.tweetText.textAlignment = (tweetAtIndexPath.lang == "ar") ? .right : .left
            }
            
            if let quotedTweetAtIndexPath = timeline?.includes.tweets?.first(where: {$0.id == tweetAtIndexPath.referenced_tweets![0].id}) {
                cell.quoteView.isHidden = false
                cell.quotedText.text = quotedTweetAtIndexPath.text
                cell.quotedText.textAlignment = (quotedTweetAtIndexPath.lang == "ar") ? .right : .left
                if let quotedAuthor = timeline?.includes.users.first(where: {$0.id == quotedTweetAtIndexPath.author_id}) {
                    cell.quotedName.text = quotedAuthor.name
                    cell.quotedHandle.text = "@\(quotedAuthor.username)"
                    cell.isQuotedVerified.isHidden = !(quotedAuthor.verified)
                    cell.isQuotedPrivate.isHidden = !(quotedAuthor.protected)
                    cell.quotedAvi.downloadImage(from: quotedAuthor.profile_image_url!)
                }
            }
        case "retweeted":
            if let retweeter = timeline?.includes.users.first(where: {$0.id == tweetAtIndexPath.author_id}) {
                cell.retweetedByLabel.isHidden = false
                cell.retweetedByLabel.text = "Retweeted By \(retweeter.name)"
            }
            if let retweetedTweet = timeline?.includes.tweets?.first(where: {$0.id == tweetAtIndexPath.referenced_tweets![0].id}){
                cell.tweetText.text = retweetedTweet.text
                cell.retweetButton.setTitle(retweetedTweet.public_metrics.retweet_count.kFormattedString, for: .normal)
                cell.likeButton.setTitle(retweetedTweet.public_metrics.like_count.kFormattedString, for: .normal)
                cell.replyButton.setTitle(retweetedTweet.public_metrics.reply_count.kFormattedString, for: .normal)
                cell.tweetText.textAlignment = (tweetAtIndexPath.lang == "ar") ? .right : .left
                if let retweetedUser = timeline?.includes.users.first(where: {$0.id == retweetedTweet.author_id}){
                    cell.authorName.text = retweetedUser.name
                    cell.authorHandle.text = "@\(retweetedUser.username)"
                    cell.isAuthorVerified.isHidden = !(retweetedUser.verified)
                    cell.isAuthorPrivate.isHidden = !(retweetedUser.protected)
                    cell.authorAvi.downloadImage(from: retweetedUser.profile_image_url!)
                }
                if let retweetedReference = retweetedTweet.referenced_tweets?[0] , retweetedReference.type == "quoted" {
                    cell.quoteView.isHidden = false
                    if let quotedTweet = timeline?.includes.tweets?.first(where: {$0.id == retweetedReference.id}) {
                        cell.quotedText.text = quotedTweet.text
                        cell.quotedText.textAlignment = (quotedTweet.lang == "ar") ? .right : .left
                        if let quotedUser = timeline?.includes.users.first(where: {$0.id == quotedTweet.author_id}){
                            cell.quotedName.text = quotedUser.name
                            cell.quotedHandle.text = "@\(quotedUser.username)"
                            cell.isQuotedPrivate.isHidden = !(quotedUser.protected)
                            cell.isQuotedVerified.isHidden = !(quotedUser.verified)
                            cell.quotedAvi.downloadImage(from: quotedUser.profile_image_url!)
                        }
                    }
                }else {
                    cell.quoteView.isHidden = true
                }
            }
        case nil:
            if let authorOfTweetAtIndexPath = timeline?.includes.users.first(where: {$0.id == tweetAtIndexPath.author_id}) {
                cell.quoteView.isHidden = true
                cell.authorName.text = authorOfTweetAtIndexPath.name
                cell.authorHandle.text = "@\(authorOfTweetAtIndexPath.username)"
                cell.isAuthorVerified.isHidden = !(authorOfTweetAtIndexPath.verified)
                cell.isAuthorPrivate.isHidden = !(authorOfTweetAtIndexPath.protected)
                cell.retweetedByLabel.isHidden = true
                cell.tweetText.text = tweetAtIndexPath.text
                cell.tweetText.textAlignment = (tweetAtIndexPath.lang == "ar") ? .right : .left
                cell.retweetButton.setTitle(tweetAtIndexPath.public_metrics.retweet_count.kFormattedString, for: .normal)
                cell.likeButton.setTitle(tweetAtIndexPath.public_metrics.like_count.kFormattedString, for: .normal)
                cell.replyButton.setTitle(tweetAtIndexPath.public_metrics.reply_count.kFormattedString, for: .normal)
                cell.authorAvi.downloadImage(from: authorOfTweetAtIndexPath.profile_image_url!)
            }
        case .some:
            if let authorOfTweetAtIndexPath = timeline?.includes.users.first(where: {$0.id == tweetAtIndexPath.author_id}) {
                cell.quoteView.isHidden = true
                cell.authorName.text = authorOfTweetAtIndexPath.name
                cell.authorHandle.text = "@\(authorOfTweetAtIndexPath.username)"
                cell.isAuthorVerified.isHidden = !(authorOfTweetAtIndexPath.verified)
                cell.isAuthorPrivate.isHidden = !(authorOfTweetAtIndexPath.protected)
                cell.retweetedByLabel.isHidden = true
                cell.tweetText.text = tweetAtIndexPath.text
                cell.tweetText.textAlignment = (tweetAtIndexPath.lang == "ar") ? .right : .left
                cell.retweetButton.setTitle(tweetAtIndexPath.public_metrics.retweet_count.kFormattedString, for: .normal)
                cell.likeButton.setTitle(tweetAtIndexPath.public_metrics.like_count.kFormattedString, for: .normal)
                cell.replyButton.setTitle(tweetAtIndexPath.public_metrics.reply_count.kFormattedString, for: .normal)
                cell.authorAvi.downloadImage(from: authorOfTweetAtIndexPath.profile_image_url!)
            }
        }
    }
}
