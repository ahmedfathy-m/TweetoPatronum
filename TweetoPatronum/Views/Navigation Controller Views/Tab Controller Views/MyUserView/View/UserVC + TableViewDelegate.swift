//
//  UserVC + TableViewDelegate.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 30/07/2022.
//

import UIKit

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
