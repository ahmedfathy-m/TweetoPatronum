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
//            try await viewModel.fetchUserBanner()
            try await viewModel.fetchQueriedTweets()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        initViewModel()
        tableView.register(HeaderView.nib(), forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
        tableView.register(TweetElementCell.nib(), forCellReuseIdentifier: TweetElementCell.identifier)
        
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

extension UserViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as! HeaderView
        viewModel.configureHeader(header)
        return header
    }

}

// MARK: - Table view data source
extension UserViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("no of cells")
        print(viewModel.queriedTweetsCount)
        return viewModel.queriedTweetsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TweetElementCell.identifier, for: indexPath) as! TweetElementCell
        viewModel.configureCell(cell, at: indexPath)
        return cell
    }
}

extension UserViewController: ViewModelDelegate {
    func didUpdateDataModel() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
