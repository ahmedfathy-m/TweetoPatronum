//
//  UserViewModel.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 23/07/2022.
//

import UIKit

class UserViewModel: ViewModelProtocol {
    var viewHasHeader: Bool{
        return true
    }
    
    private let handler:TwitterHandler
    weak var delegate: ViewModelDelegate? = nil
    
    private var user:TwitterUser? = nil {
        didSet{
            self.delegate?.didUpdateDataModel()
        }
    }
    
    private var displayedTweets: Timeline? = nil{
        didSet{
            self.delegate?.didUpdateDataModel()
        }
    }
    
    private var profileBanner: ProfileHeader? = nil{
        didSet{
            self.delegate?.didUpdateDataModel()
        }
    }
    
    var entryCount: Int{
        return displayedTweets?.data.count ?? 0
    }
    
    init(handler: TwitterHandler){
        self.handler = handler
    }
    
    //Fetch Data for Models
    
    fileprivate func fetchMyUser() async throws{
        let response = try await handler.fetchMyUser()
        if response.1 == 200{
            user = response.0
        }else{
            let alert = await UIAlertController(title: "Oh Crap", message: "Oh Crap", preferredStyle: .alert)
            await delegate?.present(alert, animated: true)
        }
    }
    
    func fetchDataModel() async throws{
        try await fetchMyUser()
        if let myUserID = user?.data.id {
            displayedTweets = try await handler.fetchUserTweets(using: myUserID).0
        }
    }
    
    func fetchUserBanner() async throws{
        if let myUserID = user?.data.id {
            profileBanner = try await handler.getUserBanner(using: myUserID).0
        }
    }
    
    //UI Configure
    func configureHeader(_ header: HeaderView){
        header.tweetsQuery.isSelected = true
        header.infoView.layer.cornerRadius = header.infoView.frame.height / 2
        header.barSelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        if let myUser = user?.data{
            header.userBio.text = myUser.description
            header.userDisplayName.text = myUser.name
            header.userHandle.text = "@\(myUser.username)"
            if let avatarURL = myUser.profile_image_url{
                header.profileImageView.downloadImage(from: avatarURL)
                header.profileImageView.layer.cornerRadius = header.profileImageView.bounds.height / 2
                header.profileImageView.clipsToBounds = true
            }
        }
    }
    
    func configure(_ cell: TweetElementCell,at indexPath:IndexPath){
        let tweetIndex = indexPath.row
        guard let tweetAtIndexPath = displayedTweets?.data[tweetIndex] else { return }
        if let reference = tweetAtIndexPath.referencedTweets?[0].type, let refTweet = displayedTweets?.includes.tweets?.first(where: {$0.id == tweetAtIndexPath.referencedTweets?[0].id}) {
            switch reference {
            case "retweeted":
                if let refUser = displayedTweets?.includes.users.first(where: {$0.id == refTweet.authorID}) {
                    cell.quoteView.isHidden = true
                    cell.retweetedByLabel.isHidden = false
                    cell.retweetedByLabel.text = "You Retweeted"
                    cell.authorName.text = refUser.name
                    cell.authorHandle.text = "@\(refUser.username)"
                    cell.authorAvi.downloadImage(from: refUser.profile_image_url!)
                    cell.isAuthorPrivate.isHidden = !(refUser.protected)
                    cell.isAuthorVerified.isHidden = !(refUser.verified)
                    //                    cell.tweetText.text = refTweet.text
                    cell.tweetText.attributedText = refTweet.computedText
                    cell.retweetButton.setTitle(refTweet.publicMetrics.retweet_count.kFormattedString, for: .normal)
                    cell.likeButton.setTitle(refTweet.publicMetrics.like_count.kFormattedString, for: .normal)
                    cell.replyButton.setTitle(refTweet.publicMetrics.reply_count.kFormattedString, for: .normal)
                }
            case "quoted":
                if let refUser = displayedTweets?.includes.users.first(where: {$0.id == refTweet.authorID}), let tweetUser = user?.data{
                    cell.retweetedByLabel.isHidden = true
                    cell.authorName.text = tweetUser.name
                    cell.authorHandle.text = "@\(tweetUser.username)"
                    cell.authorAvi.downloadImage(from: tweetUser.profile_image_url!)
                    cell.isAuthorPrivate.isHidden = !(tweetUser.protected)
                    cell.isAuthorVerified.isHidden = !(tweetUser.verified)
                    //                    cell.tweetText.text = tweetAtIndexPath.text
                    cell.tweetText.attributedText = tweetAtIndexPath.computedText
                    cell.retweetButton.setTitle(tweetAtIndexPath.publicMetrics.retweet_count.kFormattedString, for: .normal)
                    cell.likeButton.setTitle(tweetAtIndexPath.publicMetrics.like_count.kFormattedString, for: .normal)
                    cell.replyButton.setTitle(tweetAtIndexPath.publicMetrics.reply_count.kFormattedString, for: .normal)
                    
                    //Quoted Tweet
                    cell.quoteView.isHidden = false
                    cell.quotedName.text = refUser.name
                    cell.quotedHandle.text = refUser.username
                    cell.quotedAvi.downloadImage(from: refUser.profile_image_url!)
                    cell.isQuotedVerified.isHidden = !(refUser.verified)
                    cell.isQuotedPrivate.isHidden = !(refUser.protected)
                    cell.quotedText.text = refTweet.text
                }
            default:
                if let tweetUser = user?.data {
                    cell.quoteView.isHidden = true
                    cell.retweetedByLabel.isHidden = true
                    cell.authorName.text = tweetUser.name
                    cell.authorHandle.text = "@\(tweetUser.username)"
                    cell.authorAvi.downloadImage(from: tweetUser.profile_image_url!)
                    cell.isAuthorPrivate.isHidden = !(tweetUser.protected)
                    cell.isAuthorVerified.isHidden = !(tweetUser.verified)
                    //                    cell.tweetText.text = tweetAtIndexPath.text
                    cell.tweetText.attributedText = tweetAtIndexPath.computedText
                    cell.retweetButton.setTitle(tweetAtIndexPath.publicMetrics.retweet_count.kFormattedString, for: .normal)
                    cell.likeButton.setTitle(tweetAtIndexPath.publicMetrics.like_count.kFormattedString, for: .normal)
                    cell.replyButton.setTitle(tweetAtIndexPath.publicMetrics.reply_count.kFormattedString, for: .normal)
                }
            }
        } else {
            if let tweetUser = user?.data {
                cell.quoteView.isHidden = true
                cell.retweetedByLabel.isHidden = true
                cell.authorName.text = tweetUser.name
                cell.authorHandle.text = "@\(tweetUser.username)"
                cell.authorAvi.downloadImage(from: tweetUser.profile_image_url!)
                cell.isAuthorPrivate.isHidden = !(tweetUser.protected)
                cell.isAuthorVerified.isHidden = !(tweetUser.verified)
                //                    cell.tweetText.text = tweetAtIndexPath.text
                cell.tweetText.attributedText = tweetAtIndexPath.computedText
                cell.retweetButton.setTitle(tweetAtIndexPath.publicMetrics.retweet_count.kFormattedString, for: .normal)
                cell.likeButton.setTitle(tweetAtIndexPath.publicMetrics.like_count.kFormattedString, for: .normal)
                cell.replyButton.setTitle(tweetAtIndexPath.publicMetrics.reply_count.kFormattedString, for: .normal)
            }
        }
    }
}
