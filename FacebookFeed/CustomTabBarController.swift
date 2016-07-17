//
//  CustomTabBarController.swift
//  FacebookFeed
//
//  Created by Chiang Chuan on 7/15/16.
//  Copyright © 2016 Chiang Chuan. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: feedController)
        navigationController.title = "News Feed"
        navigationController.tabBarItem.image = UIImage(named: "news_feed_icon")
        
        let friendRequestsController = FriendRequestsController()
        let secondNavigationController = UINavigationController(rootViewController: friendRequestsController)
        secondNavigationController.title = "Requests"
        secondNavigationController.tabBarItem.image = UIImage(named: "requests_icon")
        
        let messageVC = UIViewController()
        messageVC.navigationItem.title = "SOME TITLE"
        let messageNavigationController = UINavigationController(rootViewController: messageVC)
        messageNavigationController.title = "Messenger"
        messageNavigationController.tabBarItem.image = UIImage(named: "messenger_icon")
        
        let notificationsNavController = UINavigationController(rootViewController: UIViewController())
        notificationsNavController.title = "Notification"
        notificationsNavController.tabBarItem.image = UIImage(named: "globe_icon")
        
        let moreNavController = UINavigationController(rootViewController: UIViewController())
        moreNavController.title = "More"
        moreNavController.tabBarItem.image = UIImage(named: "more_icon")
        
        viewControllers = [navigationController, secondNavigationController, messageNavigationController, notificationsNavController, moreNavController]
        
        tabBar.translucent = false
        
        let topBorder = CALayer()
        topBorder.frame = CGRectMake(0,0,100,0.5)
        topBorder.backgroundColor = UIColor.rgb(229, green: 231, blue: 235).CGColor
        
        tabBar.clipsToBounds = true
    }
}
