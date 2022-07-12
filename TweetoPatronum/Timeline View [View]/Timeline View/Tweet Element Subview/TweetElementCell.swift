//
//  TweetElementCell.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 21/06/2022.
//

import UIKit

class TweetElementCell: UITableViewCell {
    
    let currentToken = Keys.currentToken
    
    //MARK: - IBOutlets
    //Original Tweet Data
    @IBOutlet weak var authorAvi: UIButton!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorHandle: UILabel!
    @IBOutlet weak var isAuthorVerified: UIImageView!
    @IBOutlet weak var isAuthorPrivate: UIImageView!
//    @IBOutlet weak var tweetContentView: UIView!
    @IBOutlet weak var tweetText: UITextView!
    //Quoted Tweet Data
    @IBOutlet weak var quoteView: UIView!
    @IBOutlet weak var quotedAvi: UIImageView!
    @IBOutlet weak var quotedName: UILabel!
    @IBOutlet weak var quotedHandle: UILabel!
    @IBOutlet weak var isQuotedVerified: UIImageView!
    @IBOutlet weak var isQuotedPrivate: UIImageView!
    @IBOutlet weak var quotedText: UITextView!
    //Metrics
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    //MARK: - Class Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        authorAvi.imageView?.layer.cornerRadius = (authorAvi.frame.height) / 2
        print((authorAvi.frame.height) / 2)
        authorAvi.imageView?.layer.masksToBounds = true
        tweetText.backgroundColor = .white.withAlphaComponent(0.0)
        
        quoteView.layer.cornerRadius = 10
        quoteView.backgroundColor = .white
        quoteView.layer.borderWidth = 1
        quoteView.layer.borderColor = UIColor.gray.cgColor
        
        quotedAvi.layer.cornerRadius = quotedAvi.frame.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    static let identifier = "tweetElementIdentifier"
    
    static func nib() -> UINib {
        return UINib(nibName: "TweetElementCell", bundle: nil)
    }
    
    func formatThousands(_ number:Int)-> String{
        if Double(number) >= 1000.0 {
            let formattedNumber = Double(number) / 1000.0
            return "\(String(format: "%.1f", formattedNumber))K"
        }else if number == 0{
            return ""
        }else {
            return String(number)
        }
    }
    
    var tweetModel:TweetViewModel?{
        didSet{
            authorName.text = tweetModel?.displayedAuthor
            authorHandle.text = tweetModel?.displayedHandle
            tweetText.text = tweetModel?.displayedTweet
            
            authorAvi.setImage(UIImage(named: "user"), for: .normal)
            authorAvi.downloadImage(from: (tweetModel?.displayedAvatar)!)
            
            isAuthorVerified.isHidden = !((tweetModel?.isDisplayedAuthorVerified)!)
            isAuthorPrivate.isHidden = !((tweetModel?.isDisplayedAuthorPrivate)!)
  
//            likeButton.titleLabel?.text = tweetModel?.likeCount?.kFormattedString
//            retweetButton.titleLabel?.text = tweetModel?.retweetCount?.kFormattedString
//            replyButton.titleLabel?.text = tweetModel?.replyCount?.kFormattedString
            likeButton.setTitle(tweetModel?.likeCount?.kFormattedString, for: .normal)
            retweetButton.setTitle(tweetModel?.retweetCount?.kFormattedString, for: .normal)
            replyButton.setTitle(tweetModel?.replyCount?.kFormattedString, for: .normal)
            
            quoteView.isHidden = !((tweetModel?.doesContainQuote)!)
            quotedName.text = tweetModel?.quotedAuthor
            quotedHandle.text = tweetModel?.quotedHandle
            quotedText.text = tweetModel?.quotedTweet
            quotedAvi.downloadImage(from: (tweetModel?.quotedAvatar) ?? "" )
            isQuotedVerified.isHidden = !((tweetModel?.isQuotedAuthorVerified)!)
            isQuotedPrivate.isHidden = !((tweetModel?.isQuotedAuthorPrivate)!)
            

        }
    }
    
    public func fillTweetCell(index: Int, timeline:Timeline) {

        
        
//        let tweet = timeline.data[index]
//        let refTweet = tweet.referenced_tweets?[0]
//
//        if (refTweet != nil),(refTweet?.type == "retweeted") {
//            if let retweetedTweet = timeline.includes.tweets?.first(where: {$0.id == refTweet?.id}), let retweetedUser = timeline.includes.users.first(where: {$0.id == retweetedTweet.author_id}){
//                tweetText.text = retweetedTweet.text
//                authorName.text = retweetedUser.name
//                authorHandle.text = "@\(retweetedUser.username)"
//                isAuthorVerified.isHidden = !(retweetedUser.verified)
//                isAuthorPrivate.isHidden = !(retweetedUser.protected)
//
//                likeButton.setTitle(formatThousands(retweetedTweet.public_metrics.like_count), for: .normal)
//                retweetButton.setTitle(formatThousands(retweetedTweet.public_metrics.retweet_count), for: .normal)
//                replyButton.setTitle(formatThousands(retweetedTweet.public_metrics.reply_count), for: .normal)
//
//
//                Task.init {
//                    let image = try await TwitterHandler.getAvi(aviURL: retweetedUser.profile_image_url!)
//                    DispatchQueue.main.async {
//                        self.authorAvi.setImage(image, for: .normal)
//                    }
//                }
//                let nestedRefTweet = retweetedTweet.referenced_tweets?[0]
//                if (nestedRefTweet != nil), (nestedRefTweet?.type == "quoted") {
//                    print(nestedRefTweet?.type)
//                    Task.init {
//                        if let nestedTweet = try await TwitterHandler.getTweets(ids: nestedRefTweet!.id, token: currentToken){
//                            DispatchQueue.main.async {
//                                self.quoteView.isHidden = false
//                                self.quotedText.text = nestedTweet.data[0].text
//                                self.quotedName.text = nestedTweet.includes.users[0].name
//                                self.quotedHandle.text = "@\(nestedTweet.includes.users[0].username)"
//                                self.isQuotedVerified.isHidden = !(nestedTweet.includes.users[0].verified)
//                                self.isQuotedPrivate.isHidden = !(nestedTweet.includes.users[0].protected)
//                            }
//                            let image = try await TwitterHandler.getAvi(aviURL: nestedTweet.includes.users[0].profile_image_url!)
//                            DispatchQueue.main.async {
//                                self.quotedAvi.image = image
//                            }
//
//                        }
//                    }
//                }else{
//                    quoteView.isHidden = true
//                }
//            }
//
//        }else if (refTweet != nil),(refTweet?.type == "quoted") {
//            tweetText.text = tweet.text
//            if let tweetAuthor = timeline.includes.users.first(where: {$0.id == tweet.author_id}){
//                authorName.text = tweetAuthor.name
//                authorHandle.text = "@\(tweetAuthor.username)"
//                isAuthorVerified.isHidden = !(tweetAuthor.verified)
//                isAuthorPrivate.isHidden = !(tweetAuthor.protected)
//                likeButton.setTitle(formatThousands(tweet.public_metrics.like_count), for: .normal)
//                retweetButton.setTitle(formatThousands(tweet.public_metrics.retweet_count), for: .normal)
//                replyButton.setTitle(formatThousands(tweet.public_metrics.reply_count), for: .normal)
//                Task.init {
//                    let image = try await TwitterHandler.getAvi(aviURL: tweetAuthor.profile_image_url!)
//                    DispatchQueue.main.async {
//                        self.authorAvi.setImage(image, for: .normal)
//                    }
//                }
//
//            }
//
//            if let quotedTweet = timeline.includes.tweets?.first(where: {$0.id == refTweet?.id}), let quotedUser = timeline.includes.users.first(where: {$0.id == quotedTweet.author_id}){
//                quoteView.isHidden = false
//                quotedText.text = quotedTweet.text
//                quotedName.text = quotedUser.name
//                quotedHandle.text = "@\(quotedUser.username)"
//                isQuotedVerified.isHidden = !(quotedUser.verified)
//                isQuotedPrivate.isHidden = !(quotedUser.protected)
//                Task.init {
//                    let image = try await TwitterHandler.getAvi(aviURL: quotedUser.profile_image_url!)
//                    DispatchQueue.main.async {
//                        self.quotedAvi.image = image
//                    }
//                }
//            }
//        }else {
//            quoteView.isHidden = true
//            tweetText.text = tweet.text
//            if let tweetAuthor = timeline.includes.users.first(where: {$0.id == tweet.author_id}){
//                authorName.text = tweetAuthor.name
//                authorHandle.text = "@\(tweetAuthor.username)"
//                isAuthorVerified.isHidden = !(tweetAuthor.verified)
//                isAuthorPrivate.isHidden = !(tweetAuthor.protected)
//                likeButton.setTitle(formatThousands(tweet.public_metrics.like_count), for: .normal)
//                retweetButton.setTitle(formatThousands(tweet.public_metrics.retweet_count), for: .normal)
//                replyButton.setTitle(formatThousands(tweet.public_metrics.reply_count), for: .normal)
//                Task.init {
//                    let image = try await TwitterHandler.getAvi(aviURL: tweetAuthor.profile_image_url!)
//                    DispatchQueue.main.async {
//                        self.authorAvi.setImage(image, for: .normal)
//                    }
//                }
//            }
//        }
    }
    
}

