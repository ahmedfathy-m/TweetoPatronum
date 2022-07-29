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
