//
//  ViewController.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 10/06/2022.
//

import UIKit

class TimelineViewController: UITableViewController {
    private var oauth: OAuth2?
    
    lazy var viewModel: TimelineViewModel = {
        guard let tabbar = tabBarController as? TwitterTabController else {
            fatalError("Handler wasn't initalized")
        }
        return TimelineViewModel(handler: tabbar.handler)
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // TableViewCell Init
        tableView.register(TweetElementCell.nib(), forCellReuseIdentifier: TweetElementCell.identifier)
        initViewModel()
        viewModel.delegate = self

        //Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ReloadTimeline), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        
    }
    
    @objc func ReloadTimeline(refreshControl: UIRefreshControl) {
        Task.init {
            initViewModel()
            refreshControl.endRefreshing()
        }
    }
}



