//
//  MentionsVC+DataSoruce.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 30/07/2022.
//

import UIKit

extension MentionsViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataModelEntriesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TweetElementCell.identifier, for: indexPath) as! TweetElementCell
        viewModel.configure(cell, at: indexPath)
        return cell
    }
    
    
}
