//
//  AppDelegate.swift
//  TweetoPatronum
//
//  Created by Ahmed Fathy on 10/06/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let navigationController = UINavigationController()
        let appCoordinator = AppCoordinator(with: navigationController)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        print(UIScreen.main.bounds)
        
        appCoordinator.start()
        return true
    }
}

