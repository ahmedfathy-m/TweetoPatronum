//
//  ViewModelProtocol.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 30/07/2022.
//

import Foundation

protocol ViewModelProtocol: AnyObject {
//    var delegate:ViewModelDelegate? {get set}
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
