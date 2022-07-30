//
//  UserVC + ViewModel.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 30/07/2022.
//

import UIKit

extension UserViewController: ViewModelDelegate {
    func didUpdateDataModel() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
