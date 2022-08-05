//
//  MultiCellViewController.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 03/08/2022.
//

import UIKit

class MultiCellViewController: UIViewController {
    var viewModel:ViewModelProtocol? = nil
    var tableViewHandler: TableViewHandler? = nil
    
    weak var coordinator: Coordinator?
//    @IBOutlet weak var tableView: UITableView?
    var tableView: UITableView = UITableView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(HeaderView.nib(), forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
        tableView.register(TweetElementCell.nib(), forCellReuseIdentifier: TweetElementCell.identifier)
        tableView.dataSource = tableViewHandler
        tableView.delegate = tableViewHandler
        viewModel?.delegate = self
        initViewModel()
    }
}

extension MultiCellViewController: ViewModelDelegate{
    func initViewModel() {
        Task.init {
            try await viewModel?.fetchDataModel()
            didUpdateDataModel()
        }
    }
    
    func didUpdateDataModel() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
