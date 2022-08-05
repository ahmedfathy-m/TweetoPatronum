//
//  TableViewHandler.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 03/08/2022.
//

import UIKit

class TableViewHandler: NSObject,UITableViewDataSource {
    let viewModel: ViewModelProtocol?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.entryCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TweetElementCell.identifier) as! TweetElementCell
        viewModel?.configure(cell, at: indexPath)
        return cell
    }
    
    init(with viewModel:ViewModelProtocol) {
        self.viewModel = viewModel
    }
}

extension TableViewHandler: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TableViewHandler {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (viewModel?.viewHasHeader == true) {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as! HeaderView
            viewModel?.configureHeader(header)
            return header
        }
        tableView.sectionHeaderHeight = 0
        return nil
    }
}
