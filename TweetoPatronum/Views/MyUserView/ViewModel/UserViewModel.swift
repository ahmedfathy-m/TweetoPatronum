//
//  UserViewModel.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 23/07/2022.
//

import Foundation
import UIKit

class UserViewModel {
    private let handler:TwitterHandler
    private var user:TwitterUser? = nil {
        didSet{
            updateView?()
        }
    }
    var updateView: (() -> Void)?
    
    init(handler: TwitterHandler){
        self.handler = handler
    }
    
    func fetchMyUser(){
        Task.init {
            user = try await handler.fetchMyUser()
        }
    }
    
    func fillHeaderData(bio: inout UILabel) {
        bio.text = user?.data.description
    }
}
