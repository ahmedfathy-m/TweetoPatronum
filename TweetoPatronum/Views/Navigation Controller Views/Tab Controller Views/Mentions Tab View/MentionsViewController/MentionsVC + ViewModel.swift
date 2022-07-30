//
//  MentionsVC+ViewModel.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 30/07/2022.
//

import UIKit

extension MentionsViewController : ViewModelDelegate {
    func initViewModel() {
        Task.init {
            try await viewModel.getMentions()
            didUpdateDataModel()
        }
    }
    
    func didUpdateDataModel() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
}
