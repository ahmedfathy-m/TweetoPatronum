//
//  ViewModelProtocol.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 30/07/2022.
//

import UIKit

protocol ViewModelProtocol: AnyObject {
//    var delegate:ViewModelDelegate? {get set}
    func configure(_ cell: TweetElementCell, at indexPath:IndexPath)
    func fetchDataModel() async throws
    var entryCount:Int {get}
    func configureHeader(_ header: HeaderView)
    var viewHasHeader:Bool {get}
}

extension ViewModelProtocol {
    weak var delegate:ViewModelDelegate? {
        get{
            return nil
        }
        set{
            
        }
    }
}

extension ViewModelProtocol where Self:TimelineViewModel {
    func configureHeader(_ header: HeaderView){
        header.isHidden = true
    }
}

extension ViewModelProtocol where Self:SearchViewModel {
    func configureHeader(_ header: HeaderView){
        header.isHidden = true
    }
}

extension ViewModelProtocol where Self:MentionsViewModel {
    func configureHeader(_ header: HeaderView){
        header.isHidden = true
    }
}
