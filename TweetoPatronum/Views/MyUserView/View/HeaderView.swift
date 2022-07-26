//
//  Header.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 23/07/2022.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userDisplayName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var userBio: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    static let identifier = "HeaderIdentifier"
    
    static func nib() -> UINib {
        return UINib(nibName: "HeaderView", bundle: nil)
    }

}
