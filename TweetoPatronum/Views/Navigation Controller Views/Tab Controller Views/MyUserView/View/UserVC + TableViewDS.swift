//
//  UserVC + TableViewDS.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 30/07/2022.
//

import UIKit

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
