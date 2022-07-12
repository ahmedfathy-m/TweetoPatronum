//
//  ViewController.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 10/06/2022.
//

import UIKit

class TimelineViewController: UITableViewController {
    var oauth: OAuth?
    var timeline: Timeline?
    let currentToken = Keys.currentToken
    
    lazy var viewModel = {
        TimelineViewModel(oauth: oauth ?? OAuth())
    }()
    
    func initViewModel(){
        viewModel.getTimeline()
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(TweetElementCell.nib(), forCellReuseIdentifier: TweetElementCell.identifier)
        

        let tabbar = tabBarController as? TwitterTabController
        self.oauth = tabbar?.oauth
        
        initViewModel()
        

        
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
    
    //MARK: - TableView Data Source Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweetModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TweetElementCell.identifier, for: indexPath) as! TweetElementCell
        cell.tweetModel = viewModel.getTweetModel(at: indexPath)
        return cell
    }
    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

