//
//  ViewController.swift
//  FacebookFeed
//
//  Created by Chiang Chuan on 7/8/16.
//  Copyright © 2016 Chiang Chuan. All rights reserved.
//

import UIKit


let CellId = "cellId"

let posts = Posts()

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        posts.append(postRyuuu)
//        posts.append(postTyrion2)
//        posts.append(postTyrion)
        let memoryCapacity = 500 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        let urlCache = NSURLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "myDiskPath")
        NSURLCache.setSharedURLCache(urlCache)
        
        
        navigationItem.title = "Facebook Feed"
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: CellId)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.numberOfPosts()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCellWithReuseIdentifier(CellId, forIndexPath: indexPath) as! FeedCell
        
        feedCell.post = posts[indexPath]
        feedCell.feedController = self
        
        return feedCell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let statusText = posts[indexPath].statusText{
            
            let rect = NSString(string: statusText).boundingRectWithSize(CGSizeMake(view.frame.width, 1000), options: NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24  + 8 + 44

            
            return CGSizeMake(view.frame.width, rect.height + knownHeight + 24)
        }
        
        return CGSizeMake(view.frame.width, 500)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    let zoomImageView = UIImageView()

    let blackBackgroundView = UIView()
    
    var statusImageView: UIImageView?
    
    let navBarCoverView = UIView()
    
    let tabBarCoverView = UIView()
    
    
    func animateImageView(statusImageView: UIImageView){
        
        self.statusImageView = statusImageView
        
        if let startingFram = statusImageView.superview?.convertRect(statusImageView.frame, toView: nil){
            
            statusImageView.alpha = 0
            
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = UIColor.blackColor()
            blackBackgroundView.alpha = 0
            view.addSubview(blackBackgroundView)
            
            
            navBarCoverView.frame = CGRectMake(0, 0, 1000, 20 + 44)
            navBarCoverView.backgroundColor = UIColor.blackColor()
            navBarCoverView.alpha = 0
            
            
            if let keyWindow = UIApplication.sharedApplication().keyWindow{
                keyWindow.addSubview(navBarCoverView)
                
                tabBarCoverView.frame = CGRectMake(0, keyWindow.frame.height - 49, 1000, 49)
                tabBarCoverView.backgroundColor = UIColor.blackColor()
                tabBarCoverView.alpha = 0
                keyWindow.addSubview(tabBarCoverView)

            }
            
            
            zoomImageView.backgroundColor = UIColor.redColor()
            zoomImageView.frame = startingFram
            zoomImageView.userInteractionEnabled = true
            zoomImageView.image = statusImageView.image
            zoomImageView.contentMode = .ScaleAspectFill
            zoomImageView.clipsToBounds = true
            view.addSubview(zoomImageView)
            
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.zoomOut)))
            
            
            UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .CurveEaseOut, animations: {() -> Void in
                let height = startingFram.height * self.view.frame.width / startingFram.width
                let y = ((self.view.frame.height - height) / 2 + 49)
                self.zoomImageView.frame = CGRectMake(0, y, self.view.frame.width, height)
                
                self.blackBackgroundView.alpha = 1
                
                self.navBarCoverView.alpha = 1
                
                self.tabBarCoverView.alpha = 1

                }, completion: nil)
            
            
            

        }
        

    }
    
    func zoomOut(){
        if let startingFram = statusImageView!.superview?.convertRect(statusImageView!.frame, toView: nil){
            
            
            
            UIView.animateWithDuration(0.75, animations: {() -> Void in
                self.zoomImageView.frame = startingFram
                
                self.blackBackgroundView.alpha = 0
                self.navBarCoverView.alpha = 0
                self.tabBarCoverView.alpha = 0

                }, completion: {(didComplete) -> Void in
                    self.zoomImageView.removeFromSuperview()
                    self.blackBackgroundView.removeFromSuperview()
                    self.navBarCoverView.removeFromSuperview()
                    self.tabBarCoverView.removeFromSuperview()
                    self.statusImageView?.alpha = 1
            })
        
        }
        
    }
    
}

