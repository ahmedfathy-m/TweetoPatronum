//
//  MentionsViewModel.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 30/07/2022.
//

import Foundation

class MentionsViewModel:ViewModelProtocol{
    
    private let handler:TwitterHandler
    
    private var dataModel: Timeline? = nil{
        didSet{
            delegate?.didUpdateDataModel()
        }
    }
    
    var dataModelEntriesCount: Int{
        dataModel?.data.count ?? 0
    }
    
    init(handler: TwitterHandler) {
        self.handler = handler
    }
    
    func getMentions() async throws{
        dataModel = try await handler.getIncomingMentions(using: handler.userID).0
    }
    
    func configure(_ cell: TweetElementCell, at indexPath:IndexPath){
        guard let tweetAtIndexPath = dataModel?.data[indexPath.row] else {return}
        let reference = tweetAtIndexPath.referenced_tweets?[0].type
        switch reference{
        case "quoted":
            if let authorOfTweetAtIndexPath = dataModel?.includes.users.first(where: {$0.id == tweetAtIndexPath.author_id}) {
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
            
            if let quotedTweetAtIndexPath = dataModel?.includes.tweets?.first(where: {$0.id == tweetAtIndexPath.referenced_tweets![0].id}) {
                cell.quoteView.isHidden = false
                cell.quotedText.text = quotedTweetAtIndexPath.text
                cell.quotedText.textAlignment = (quotedTweetAtIndexPath.lang == "ar") ? .right : .left
                if let quotedAuthor = dataModel?.includes.users.first(where: {$0.id == quotedTweetAtIndexPath.author_id}) {
                    cell.quotedName.text = quotedAuthor.name
                    cell.quotedHandle.text = "@\(quotedAuthor.username)"
                    cell.isQuotedVerified.isHidden = !(quotedAuthor.verified)
                    cell.isQuotedPrivate.isHidden = !(quotedAuthor.protected)
                    cell.quotedAvi.downloadImage(from: quotedAuthor.profile_image_url!)
                }
            }
        case "retweeted":
            if let retweeter = dataModel?.includes.users.first(where: {$0.id == tweetAtIndexPath.author_id}) {
                cell.retweetedByLabel.isHidden = false
                cell.retweetedByLabel.text = "Retweeted By \(retweeter.name)"
            }
            if let retweetedTweet = dataModel?.includes.tweets?.first(where: {$0.id == tweetAtIndexPath.referenced_tweets![0].id}){
                cell.tweetText.text = retweetedTweet.text
                cell.retweetButton.setTitle(retweetedTweet.public_metrics.retweet_count.kFormattedString, for: .normal)
                cell.likeButton.setTitle(retweetedTweet.public_metrics.like_count.kFormattedString, for: .normal)
                cell.replyButton.setTitle(retweetedTweet.public_metrics.reply_count.kFormattedString, for: .normal)
                cell.tweetText.textAlignment = (tweetAtIndexPath.lang == "ar") ? .right : .left
                if let retweetedUser = dataModel?.includes.users.first(where: {$0.id == retweetedTweet.author_id}){
                    cell.authorName.text = retweetedUser.name
                    cell.authorHandle.text = "@\(retweetedUser.username)"
                    cell.isAuthorVerified.isHidden = !(retweetedUser.verified)
                    cell.isAuthorPrivate.isHidden = !(retweetedUser.protected)
                    cell.authorAvi.downloadImage(from: retweetedUser.profile_image_url!)
                }
                if let retweetedReference = retweetedTweet.referenced_tweets?[0] , retweetedReference.type == "quoted" {
                    cell.quoteView.isHidden = false
                    if let quotedTweet = dataModel?.includes.tweets?.first(where: {$0.id == retweetedReference.id}) {
                        cell.quotedText.text = quotedTweet.text
                        cell.quotedText.textAlignment = (quotedTweet.lang == "ar") ? .right : .left
                        if let quotedUser = dataModel?.includes.users.first(where: {$0.id == quotedTweet.author_id}){
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
            if let authorOfTweetAtIndexPath = dataModel?.includes.users.first(where: {$0.id == tweetAtIndexPath.author_id}) {
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
            if let authorOfTweetAtIndexPath = dataModel?.includes.users.first(where: {$0.id == tweetAtIndexPath.author_id}) {
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
