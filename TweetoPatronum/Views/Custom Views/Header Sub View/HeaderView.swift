//
//  Header.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 23/07/2022.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userDisplayName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var userBio: UILabel!
    @IBOutlet weak var tweetsQuery: UIButton!
    @IBOutlet weak var barSelector: UISegmentedControl!
    @IBOutlet weak var infoView: UIView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    static let identifier = "HeaderIdentifier"
    
    static func nib() -> UINib {
        return UINib(nibName: "HeaderView", bundle: nil)
    }
    
    @IBAction func queryButton(_ sender: UIButton) {
        sender.superview?.subviews.forEach({ view in
            let button = view as! UIButton
            button.isSelected = false
        })
        sender.isSelected = true
    }
    

}
