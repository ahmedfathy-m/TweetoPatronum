//
//  BaseCoordinator.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 02/08/2022.
//

import UIKit

protocol Coordinator: AnyObject{
    func start()
    func removeCoordinator(coordinator: Coordinator)
}

class BaseCoordinator: Coordinator {
    //Global Auth and Networking Handlers
    var oauth = OAuth2(id: "blh4NEl6N04wQXlBWmZwcWRJT1Q6MTpjaQ", callback: "https://www.blank.org")
    lazy var handler:TwitterHandler = { return TwitterHandler(oauth) }()
    
    //Global Navigation and ChildCoordinator Array
    let navigationController: UINavigationController
    var childCoordinators = [BaseCoordinator]()
    
    func start() {
        
    }
    
    func removeCoordinator(coordinator: Coordinator) {
        if let index:Int = childCoordinators.firstIndex(where: {$0 === coordinator}) {
            childCoordinators.remove(at: index)
        }
    }

    init(with navCon: UINavigationController) {
        self.navigationController = navCon
        print(self)
    }
}
