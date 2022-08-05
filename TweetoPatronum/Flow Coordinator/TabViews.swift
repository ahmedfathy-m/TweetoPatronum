//
//  ViewControllerRouter.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 03/08/2022.
//

import Foundation
import UIKit

enum TabView {
    case timeline(_ handler: TwitterHandler)
    case mentions(_ handler: TwitterHandler)
    case search(_ handler: TwitterHandler)
    case user(_ handler: TwitterHandler)

    var viewModel: ViewModelProtocol {
        switch self {
        case .timeline(let handler):
            return TimelineViewModel(handler: handler)
        case .mentions(let handler):
            return MentionsViewModel(handler: handler)
        case .search(let handler):
            return SearchViewModel()
        case .user(let handler):
            return UserViewModel(handler: handler)
        }
    }
    
    var viewTitle:(String,UIImage?){
        switch self {
        case .timeline:
            return ("Home", UIImage(systemName: "house.fill"))
        case .mentions:
            return ("Mentions",UIImage(systemName: "bell.badge.fill"))
        case .search:
            return ("Search",UIImage(systemName: "magnifyingglass"))
        case .user:
            return ("Me",UIImage(systemName: "person.fill"))
        }
    }
}
