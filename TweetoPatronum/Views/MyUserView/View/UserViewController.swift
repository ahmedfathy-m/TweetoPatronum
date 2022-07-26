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
        viewModel.fetchMyUser()
        viewModel.updateView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(HeaderView.nib(), forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
        initViewModel()
    }
}

extension UserViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as! HeaderView
        header.userDisplayName.text = "My Ugly Ass"
        viewModel.fillHeaderData(bio: &header.userBio)
        print(header.bounds.size)
        print(header.frame.size)
        return header
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 475
//    }
}

// MARK: - Table view data source
extension UserViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMe", for: indexPath)
        cell.textLabel?.text = "Added Cell"
        return cell
    }
}
