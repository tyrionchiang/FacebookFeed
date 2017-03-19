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
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "myDiskPath")
        URLCache.shared = urlCache
        
        
        navigationItem.title = "Facebook Feed"
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: CellId)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.numberOfPosts()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! FeedCell
        
        feedCell.post = posts[indexPath]
        feedCell.feedController = self
        
        return feedCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let statusText = posts[indexPath].statusText{
            
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24  + 8 + 44

            
            return CGSize(width: view.frame.width, height: rect.height + knownHeight + 24)
        }
        
        return CGSize(width: view.frame.width, height: 500)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    let zoomImageView = UIImageView()

    let blackBackgroundView = UIView()
    
    var statusImageView: UIImageView?
    
    let navBarCoverView = UIView()
    
    let tabBarCoverView = UIView()
    
    
    func animateImageView(_ statusImageView: UIImageView){
        
        self.statusImageView = statusImageView
        
        if let startingFram = statusImageView.superview?.convert(statusImageView.frame, to: nil){
            
            statusImageView.alpha = 0
            
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = UIColor.black
            blackBackgroundView.alpha = 0
            view.addSubview(blackBackgroundView)
            
            
            navBarCoverView.frame = CGRect(x: 0, y: 0, width: 1000, height: 20 + 44)
            navBarCoverView.backgroundColor = UIColor.black
            navBarCoverView.alpha = 0
            
            
            if let keyWindow = UIApplication.shared.keyWindow{
                keyWindow.addSubview(navBarCoverView)
                
                tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - 49, width: 1000, height: 49)
                tabBarCoverView.backgroundColor = UIColor.black
                tabBarCoverView.alpha = 0
                keyWindow.addSubview(tabBarCoverView)

            }
            
            
            zoomImageView.backgroundColor = UIColor.red
            zoomImageView.frame = startingFram
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = statusImageView.image
            zoomImageView.contentMode = .scaleAspectFill
            zoomImageView.clipsToBounds = true
            view.addSubview(zoomImageView)
            
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.zoomOut)))
            
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {() -> Void in
                let height = startingFram.height * self.view.frame.width / startingFram.width
                let y = ((self.view.frame.height - height) / 2 + 49)
                self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                
                self.blackBackgroundView.alpha = 1
                
                self.navBarCoverView.alpha = 1
                
                self.tabBarCoverView.alpha = 1

                }, completion: nil)
            
            
            

        }
        

    }
    
    func zoomOut(){
        if let startingFram = statusImageView!.superview?.convert(statusImageView!.frame, to: nil){
            
            
            
            UIView.animate(withDuration: 0.75, animations: {() -> Void in
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

