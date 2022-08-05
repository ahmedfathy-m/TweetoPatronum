//
//  ViewModelDelegate.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 27/07/2022.
//

import UIKit

protocol ViewModelDelegate: UIViewController {
    func initViewModel()
    func didUpdateDataModel()
}

//extension ViewModelDelegate where {
//    func didUpdateDataModel(){
//        if self.view.subviews.contains(where: { view in
//            view.isKind(of: UITableView.self)
//        }){
//            let tableView = self.view.subviews.first { view in
//                view.isKind(of: UITableView.self)
//            } as! UITableView
//            DispatchQueue.main.async {
//                tableView.reloadData()
//            }
//        }
//    }
//}
