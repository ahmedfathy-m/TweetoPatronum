//
//  UserViewController.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 23/07/2022.
//

import UIKit

class UserViewController: UITableViewController {
    
    lazy var viewModel: UserViewModel = {
        guard let tabbar = tabBarController as? TwitterTabController else {
            fatalError("Handler wasn't initalized")
        }
        return UserViewModel(handler: tabbar.handler)
    }()
    
    func initViewModel(){
        Task.init {
            try await viewModel.fetchMyUser()
            try await viewModel.fetchMyUserTweets()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        initViewModel()
        tableView.register(HeaderView.nib(), forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
        tableView.register(TweetElementCell.nib(), forCellReuseIdentifier: TweetElementCell.identifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ReloadUserScreen), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func ReloadUserScreen(refreshControl: UIRefreshControl) {
        Task.init {
            initViewModel()
            refreshControl.endRefreshing()
        }
    }
}




