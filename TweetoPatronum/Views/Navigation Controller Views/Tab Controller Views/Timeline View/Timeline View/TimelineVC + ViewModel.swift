//
//  TimelineVC + ViewModel.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 30/07/2022.
//

import UIKit

extension TimelineViewController: ViewModelDelegate{
    func didUpdateDataModel() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func initViewModel(){
        viewModel.getTimeline()
        didUpdateDataModel()
    }
}
