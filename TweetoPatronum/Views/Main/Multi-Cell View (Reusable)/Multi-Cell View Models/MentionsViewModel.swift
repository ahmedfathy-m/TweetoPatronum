//
//  MentionsViewModel.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 30/07/2022.
//

import Foundation

class MentionsViewModel:ViewModelProtocol{
    var viewHasHeader: Bool{
        return false
    }
    

    private let handler:TwitterHandler
    
    private var dataModel: Timeline? = nil{
        didSet{
            delegate?.didUpdateDataModel()
        }
    }
    
    var entryCount: Int{
        dataModel?.data.count ?? 0
    }
    
    init(handler: TwitterHandler) {
        self.handler = handler
    }
    
    func fetchDataModel() async throws{
        dataModel = try await handler.getIncomingMentions(using: handler.userID).0
    }
    
    func configure(_ cell: TweetElementCell, at indexPath:IndexPath){
        guard let tweetAtIndexPath = dataModel?.data[indexPath.row] else {return}
        let reference = tweetAtIndexPath.referencedTweets?[0].type
        switch reference{
        case "quoted":
            if let authorOfTweetAtIndexPath = dataModel?.includes.users.first(where: {$0.id == tweetAtIndexPath.authorID}) {
                cell.authorName.text = authorOfTweetAtIndexPath.name
                cell.authorHandle.text = "@\(authorOfTweetAtIndexPath.username)"
                cell.isAuthorVerified.isHidden = !(authorOfTweetAtIndexPath.verified)
                cell.isAuthorPrivate.isHidden = !(authorOfTweetAtIndexPath.protected)
                cell.retweetedByLabel.isHidden = true
                //                cell.tweetText.text = tweetAtIndexPath.text
                cell.tweetText.attributedText = tweetAtIndexPath.computedText
                cell.retweetButton.setTitle(tweetAtIndexPath.publicMetrics.retweet_count.kFormattedString, for: .normal)
                cell.likeButton.setTitle(tweetAtIndexPath.publicMetrics.like_count.kFormattedString, for: .normal)
                cell.replyButton.setTitle(tweetAtIndexPath.publicMetrics.reply_count.kFormattedString, for: .normal)
                cell.authorAvi.downloadImage(from: authorOfTweetAtIndexPath.profile_image_url!)
                cell.tweetText.textAlignment = (tweetAtIndexPath.lang == "ar") ? .right : .left
            }
            
            if let quotedTweetAtIndexPath = dataModel?.includes.tweets?.first(where: {$0.id == tweetAtIndexPath.referencedTweets![0].id}) {
                cell.quoteView.isHidden = false
                cell.quotedText.text = quotedTweetAtIndexPath.text
                cell.quotedText.textAlignment = (quotedTweetAtIndexPath.lang == "ar") ? .right : .left
                if let quotedAuthor = dataModel?.includes.users.first(where: {$0.id == quotedTweetAtIndexPath.authorID}) {
                    cell.quotedName.text = quotedAuthor.name
                    cell.quotedHandle.text = "@\(quotedAuthor.username)"
                    cell.isQuotedVerified.isHidden = !(quotedAuthor.verified)
                    cell.isQuotedPrivate.isHidden = !(quotedAuthor.protected)
                    cell.quotedAvi.downloadImage(from: quotedAuthor.profile_image_url!)
                }
            }
        case "retweeted":
            if let retweeter = dataModel?.includes.users.first(where: {$0.id == tweetAtIndexPath.authorID}) {
                cell.retweetedByLabel.isHidden = false
                cell.retweetedByLabel.text = "Retweeted By \(retweeter.name)"
            }
            if let retweetedTweet = dataModel?.includes.tweets?.first(where: {$0.id == tweetAtIndexPath.referencedTweets![0].id}){
                //                cell.tweetText.text = retweetedTweet.text
                cell.tweetText.attributedText = retweetedTweet.computedText
                cell.retweetButton.setTitle(retweetedTweet.publicMetrics.retweet_count.kFormattedString, for: .normal)
                cell.likeButton.setTitle(retweetedTweet.publicMetrics.like_count.kFormattedString, for: .normal)
                cell.replyButton.setTitle(retweetedTweet.publicMetrics.reply_count.kFormattedString, for: .normal)
                cell.tweetText.textAlignment = (tweetAtIndexPath.lang == "ar") ? .right : .left
                if let retweetedUser = dataModel?.includes.users.first(where: {$0.id == retweetedTweet.authorID}){
                    cell.authorName.text = retweetedUser.name
                    cell.authorHandle.text = "@\(retweetedUser.username)"
                    cell.isAuthorVerified.isHidden = !(retweetedUser.verified)
                    cell.isAuthorPrivate.isHidden = !(retweetedUser.protected)
                    cell.authorAvi.downloadImage(from: retweetedUser.profile_image_url!)
                }
                if let retweetedReference = retweetedTweet.referencedTweets?[0] , retweetedReference.type == "quoted" {
                    cell.quoteView.isHidden = false
                    if let quotedTweet = dataModel?.includes.tweets?.first(where: {$0.id == retweetedReference.id}) {
                        cell.quotedText.text = quotedTweet.text
                        cell.quotedText.textAlignment = (quotedTweet.lang == "ar") ? .right : .left
                        if let quotedUser = dataModel?.includes.users.first(where: {$0.id == quotedTweet.authorID}){
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
            if let authorOfTweetAtIndexPath = dataModel?.includes.users.first(where: {$0.id == tweetAtIndexPath.authorID}) {
                cell.quoteView.isHidden = true
                cell.authorName.text = authorOfTweetAtIndexPath.name
                cell.authorHandle.text = "@\(authorOfTweetAtIndexPath.username)"
                cell.isAuthorVerified.isHidden = !(authorOfTweetAtIndexPath.verified)
                cell.isAuthorPrivate.isHidden = !(authorOfTweetAtIndexPath.protected)
                cell.retweetedByLabel.isHidden = true
                //                cell.tweetText.text = tweetAtIndexPath.text
                cell.tweetText.attributedText = tweetAtIndexPath.computedText
                cell.tweetText.textAlignment = (tweetAtIndexPath.lang == "ar") ? .right : .left
                cell.retweetButton.setTitle(tweetAtIndexPath.publicMetrics.retweet_count.kFormattedString, for: .normal)
                cell.likeButton.setTitle(tweetAtIndexPath.publicMetrics.like_count.kFormattedString, for: .normal)
                cell.replyButton.setTitle(tweetAtIndexPath.publicMetrics.reply_count.kFormattedString, for: .normal)
                cell.authorAvi.downloadImage(from: authorOfTweetAtIndexPath.profile_image_url!)
            }
        case .some:
            if let authorOfTweetAtIndexPath = dataModel?.includes.users.first(where: {$0.id == tweetAtIndexPath.authorID}) {
                cell.quoteView.isHidden = true
                cell.authorName.text = authorOfTweetAtIndexPath.name
                cell.authorHandle.text = "@\(authorOfTweetAtIndexPath.username)"
                cell.isAuthorVerified.isHidden = !(authorOfTweetAtIndexPath.verified)
                cell.isAuthorPrivate.isHidden = !(authorOfTweetAtIndexPath.protected)
                cell.retweetedByLabel.isHidden = true
                //                cell.tweetText.text = tweetAtIndexPath.text
                cell.tweetText.attributedText = tweetAtIndexPath.computedText
                cell.tweetText.textAlignment = (tweetAtIndexPath.lang == "ar") ? .right : .left
                cell.retweetButton.setTitle(tweetAtIndexPath.publicMetrics.retweet_count.kFormattedString, for: .normal)
                cell.likeButton.setTitle(tweetAtIndexPath.publicMetrics.like_count.kFormattedString, for: .normal)
                cell.replyButton.setTitle(tweetAtIndexPath.publicMetrics.reply_count.kFormattedString, for: .normal)
                cell.authorAvi.downloadImage(from: authorOfTweetAtIndexPath.profile_image_url!)
            }
        }
    }
}
