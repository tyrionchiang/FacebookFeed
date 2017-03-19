//
//  FeedCell.swift
//  FacebookFeed
//
//  Created by Chiang Chuan on 7/14/16.
//  Copyright © 2016 Chiang Chuan. All rights reserved.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

class FeedCell: UICollectionViewCell {
    
   
    
    var post: Post? {
        didSet {
            
            statusImageView.image = nil
            loader.startAnimating()
            
            if let statusImageUrl = post?.statusImageUrl {
                
                if let image = imageCache.object(forKey: statusImageUrl as AnyObject) as? UIImage {
                    statusImageView.image = image
                    loader.stopAnimating()
                } else {
                    
                    URLSession.shared.dataTask(with: URL(string: statusImageUrl)!, completionHandler: { (data, response, error) -> Void in
                        
                        if error != nil {
                            print(error!)
                            return
                        }
                        
                        let image = UIImage(data: data!)
                        
                        imageCache.setObject(image!, forKey: statusImageUrl as AnyObject)
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.statusImageView.image = image
                            self.loader.stopAnimating()
                        })
                        
                        
                    }).resume()
                    
                }
                
                
            }
            
            setupNameLocationStatusAndProfileImage()
        }
    }
    
    fileprivate func setupNameLocationStatusAndProfileImage(){
        if let name = post?.name{
            let attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)])
            
            let postTime = post?.postTime ?? "7 hrs"
            attributedText.append(NSAttributedString(string: "\n\(postTime)  •  ", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.rgb(155, green: 161, blue: 161)]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "globe_small")
            attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
            attributedText.append(NSAttributedString(attachment: attachment))
            
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
        if let numComments = post?.numComments, let numShares = post?.numShares{
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
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let statusTextView : UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.contentSize.height = 0.0
        return textView
    }()
    
    let statusImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    //like comment share Label
    let likesLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rgb(155, green: 161, blue: 161)
        //label.backgroundColor = UIColor.greenColor()
        return label
    }()
    let commentSharesLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = NSTextAlignment.right
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
    
    
    static func buttonForTitle(_ title: String, imageName: String) -> UIButton{
        let button = UIButton()
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), for: UIControlState())
        
        button.setImage(UIImage(named:imageName), for: UIControlState())
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        //button.backgroundColor = UIColor.blueColor()
        return button
    }
    
   
        
   var feedController : FeedController?
   
   func animate(){
       feedController?.animateImageView(statusImageView)
   }
   
    
    
    
    func setupViews(){
        backgroundColor = UIColor.white
        
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
        
        statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.animate)))
        
        
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
    
    let loader = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    func setupStatusImageViewLoader() {
        loader.hidesWhenStopped = true
        loader.startAnimating()
        loader.color = UIColor.black
        statusImageView.addSubview(loader)
        statusImageView.addConstraintsWithFormat("H:|[v0]|", views: loader)
        statusImageView.addConstraintsWithFormat("V:|[v0]|", views: loader)
    }
}


