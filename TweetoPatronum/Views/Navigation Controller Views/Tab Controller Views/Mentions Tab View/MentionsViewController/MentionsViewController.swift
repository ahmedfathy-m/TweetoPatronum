//
//  MentionsViewController.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 30/07/2022.
//

import UIKit

class MentionsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?
    
    lazy var viewModel: MentionsViewModel = {
        guard let tabbar = tabBarController as? TwitterTabController else {
            fatalError("Handler wasn't initalized")
        }
        return MentionsViewModel(handler: tabbar.handler)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        tableView?.register(TweetElementCell.nib(), forCellReuseIdentifier: TweetElementCell.identifier)
        initViewModel()
    }
}
