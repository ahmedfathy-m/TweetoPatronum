//
//  TimelineVC + TableViewDS.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 30/07/2022.
//

import UIKit

extension TimelineViewController {
    //MARK: - TableView Data Source Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweetCount ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TweetElementCell.identifier, for: indexPath) as! TweetElementCell
        viewModel.configureCell(cell, at: indexPath)
        return cell
    }
}
