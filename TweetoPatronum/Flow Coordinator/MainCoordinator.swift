//
//  MainCoordinator.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 03/08/2022.
//

import UIKit

class MainCoordinator: BaseCoordinator{
    let tabView = UITabBarController()
    fileprivate var navTitle: NSMutableAttributedString{
        let title = NSMutableAttributedString(string: "Tweetarium")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "twitter")
        let attachString = NSMutableAttributedString(attachment: imageAttachment)
        attachString.append(title)
        return attachString
    }
    
    override func start() {
        showTabView()
    }
    
    func showTabView(){
        initTabView()
        navigationController.pushViewController(tabView, animated: true)
        print(tabView.children.count)
    }
    
    fileprivate func initTabView(){
        let midButton = UIButton()
        midButton.frame.size = CGSize(width: 48.0, height: 48.0)
        midButton.layer.cornerRadius = midButton.frame.height / 2
        midButton.backgroundColor = .systemBlue
        midButton.tintColor = .white
        midButton.setImage(UIImage(systemName: "plus"), for: .normal)
        midButton.center = CGPoint(x: tabView.tabBar.frame.width / 2.0, y: 0)
        midButton.layer.shadowColor = UIColor.systemBlue.cgColor
        midButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        midButton.layer.shadowRadius = 5
        midButton.layer.shadowOpacity = 1.0
//        midButton.addTarget(tabView, action: #selector(createTweetPressed), for: .touchUpInside)
        tabView.tabBar.addSubview(midButton)
        
        let navLabel = UILabel()
        navLabel.attributedText = navTitle
        tabView.navigationItem.titleView = navLabel
        
        
        let view : [TabView] = [.timeline(handler),.mentions(handler), .search(handler),.user(handler)]
        view.forEach { view in
            let targetVC = MultiCellViewController()
            targetVC.title = view.viewTitle.0
            targetVC.tabBarItem.image = view.viewTitle.1
            let viewModel = view.viewModel
            targetVC.viewModel = viewModel
            targetVC.tableViewHandler = TableViewHandler(with: viewModel)
            tabView.addChild(targetVC)
        }
    }
//
//    @objc func createTweetPressed(){
//        print("some added")
//    }
    
}
