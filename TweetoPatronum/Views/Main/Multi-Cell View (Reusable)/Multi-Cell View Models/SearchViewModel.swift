//
//  SearchViewModel.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 01/08/2022.
//

import UIKit

class SearchViewModel: ViewModelProtocol {
    var viewHasHeader: Bool{
        return false
    }
    
    var entryCount: Int {
        return 0
    }
    
    func fetchDataModel() async throws {
        
    }
    
    func configure(_ cell: TweetElementCell, at indexPath: IndexPath) {
        
    }
}
