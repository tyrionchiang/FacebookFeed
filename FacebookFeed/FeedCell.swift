//
//  FeedCell.swift
//  FacebookFeed
//
//  Created by Chiang Chuan on 7/14/16.
//  Copyright © 2016 Chiang Chuan. All rights reserved.
//

import Foundation
import UIKit

var imageCache = NSCache()

class FeedCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            
            statusImageView.image = nil
            loader.startAnimating()
            
            if let statusImageUrl = post?.statusImageUrl {
                
                if let image = imageCache.objectForKey(statusImageUrl) as? UIImage {
                    statusImageView.image = image
                    loader.stopAnimating()
                } else {
                    
                    NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: statusImageUrl)!, completionHandler: { (data, response, error) -> Void in
                        
                        if error != nil {
                            print(error)
                            return
                        }
                        
                        let image = UIImage(data: data!)
                        
                        imageCache.setObject(image!, forKey: statusImageUrl)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.statusImageView.image = image
                            self.loader.stopAnimating()
                        })
                        
                        
                    }).resume()
                    
                }
                
                
            }
            
            setupNameLocationStatusAndProfileImage()
        }
    }
    
    private func setupNameLocationStatusAndProfileImage(){
        if let name = post?.name{
            let attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName:UIFont.boldSystemFontOfSize(14)])
            
            let postTime = post?.postTime ?? "7 hrs"
            attributedText.appendAttributedString(NSAttributedString(string: "\n\(postTime)  •  ", attributes: [NSFontAttributeName:UIFont.boldSystemFontOfSize(12), NSForegroundColorAttributeName: UIColor.rgb(155, green: 161, blue: 161)]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "globe_small")
            attachment.bounds = CGRectMake(0, -2, 12, 12)
            attributedText.appendAttributedString(NSAttributedString(attachment: attachment))
            
            nameLabel.attributedText = attributedText
            
        }
        
        if let statusText = post?.statusText{
            statusTextView.text = statusText
        }
        if let profileImageName = post?.profileImageName{
            profileImageView.image = UIImage(named: profileImageName)
        }
        /*
        if let statusImageName = post?.statusImageName{
            statusImageView.image = UIImage(named: statusImageName)
        }*/
        if let numLikes = post?.numLikes{
            if numLikes != 0{
                likesLabel.text = "\(String.countLabelNumToString(numLikes)) Likes"
            }
        }
        if let numComments = post?.numComments, numShares = post?.numShares{
            if (numShares != 0) && (numComments != 0){
                commentSharesLabel.text = "\(String.countLabelNumToString(numComments)) comments  \(String.countLabelNumToString(numShares)) shards"
            }else if (numShares != 0) || (numComments != 0){
                if numComments != 0{
                    commentSharesLabel.text = "\(String.countLabelNumToString(numComments)) comments"
                }else{
                    commentSharesLabel.text = "\(String.countLabelNumToString(numShares)) shards"
                }
            }
            
        }

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "")
        imageView.contentMode = .ScaleAspectFit
        
        return imageView
    }()
    
    let statusTextView : UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.font = UIFont.systemFontOfSize(14)
        textView.scrollEnabled = false
        textView.contentSize.height = 0.0
        return textView
    }()
    
    let statusImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "")
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    //like comment share Label
    let likesLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.rgb(155, green: 161, blue: 161)
        //label.backgroundColor = UIColor.greenColor()
        return label
    }()
    let commentSharesLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = NSTextAlignment.Right
        label.textColor = UIColor.rgb(155, green: 161, blue: 161)
        //label.backgroundColor = UIColor.greenColor()
        return label
    }()
    
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(226, green: 228, blue: 232)
        return view
    }()
    
    let likeButton: UIButton = FeedCell.buttonForTitle("Like", imageName: "like")
    let commentButton: UIButton = FeedCell.buttonForTitle("Comment", imageName: "comment")
    let shareButton: UIButton = FeedCell.buttonForTitle("Share", imageName: "share")
    
    
    static func buttonForTitle(title: String, imageName: String) -> UIButton{
        let button = UIButton()
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), forState: .Normal)
        
        button.setImage(UIImage(named:imageName), forState: .Normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
        //button.backgroundColor = UIColor.blueColor()
        return button
    }
    
    
    
    func setupViews(){
        backgroundColor = UIColor.whiteColor()
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(likesLabel)
        addSubview(commentSharesLabel)
        addSubview(dividerLineView)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        
        setupStatusImageViewLoader()
        
        //H
        addConstraintsWithFormat("H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        
        addConstraintsWithFormat("H:|-4-[v0]-4-|", views: statusTextView)
        
        addConstraintsWithFormat("H:|[v0]|", views: statusImageView)
        
        addConstraintsWithFormat("H:|-12-[v0(140)][v1]-12-|", views: likesLabel, commentSharesLabel)
        
        addConstraintsWithFormat("H:|-12-[v0]-12-|", views: dividerLineView)
        
        //button constrainst
        addConstraintsWithFormat("H:|[v0(v2)][v1(v2)][v2]|", views: likeButton, commentButton,shareButton)
        
        //V
        addConstraintsWithFormat("V:|-12-[v0]", views: nameLabel)
        
        addConstraintsWithFormat("V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(0.4)][v5(44)]|", views: profileImageView, statusTextView, statusImageView, likesLabel, dividerLineView, likeButton)
        
        addConstraintsWithFormat("V:[v0(24)]-52.4-|", views: commentSharesLabel)
        
        addConstraintsWithFormat("V:[v0(44)]|", views: commentButton)
        addConstraintsWithFormat("V:[v0(44)]|", views: shareButton)
        
    }
    
    let loader = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    func setupStatusImageViewLoader() {
        loader.hidesWhenStopped = true
        loader.startAnimating()
        loader.color = UIColor.blackColor()
        statusImageView.addSubview(loader)
        statusImageView.addConstraintsWithFormat("H:|[v0]|", views: loader)
        statusImageView.addConstraintsWithFormat("V:|[v0]|", views: loader)
    }
}


