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
    @IBOutlet weak var retweetedByLabel: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    //Quoted Tweet Data
    @IBOutlet weak var quoteView: UIView!
    @IBOutlet weak var quotedAvi: UIImageView!
    @IBOutlet weak var quotedName: UILabel!
    @IBOutlet weak var quotedHandle: UILabel!
    @IBOutlet weak var isQuotedVerified: UIImageView!
    @IBOutlet weak var isQuotedPrivate: UIImageView!
    @IBOutlet weak var quotedText: UILabel!
    //Metrics
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    //MARK: - Class Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        authorAvi.imageView?.layer.cornerRadius = (authorAvi.frame.height) / 2
        authorAvi.imageView?.layer.masksToBounds = true
        tweetText.backgroundColor = .white.withAlphaComponent(0.0)
        
        quoteView.layer.cornerRadius = 10
        quoteView.backgroundColor = .white
        quoteView.layer.borderWidth = 1
        quoteView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        
        quotedAvi.layer.cornerRadius = quotedAvi.frame.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "tweetElementIdentifier"
    
    static func nib() -> UINib {
        return UINib(nibName: "TweetElementCell", bundle: nil)
    }
}

