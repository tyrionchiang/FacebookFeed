//
//  ViewController.swift
//  FacebookFeed
//
//  Created by Chiang Chuan on 7/8/16.
//  Copyright © 2016 Chiang Chuan. All rights reserved.
//

import UIKit

let CellId = "cellId"

class Post{
    var name: String?
    var statusText: String?
    var profileImageName: String?
    var statusImageName: String?
    var numLikes: Int?
    var numComments: Int?
    var numShares: Int?
}


class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postRyuuu = Post()
        postRyuuu.name = "Ryuuu TV / 學日文看日本"
        postRyuuu.statusText = "台灣的朋友們，昨天的颱風還好嗎？看了幾則覺得這次颱風好恐怖的新聞⋯嫌だね。\n照片是我（ryu）今早看手機覺得很可愛的想說分享一下"
        postRyuuu.profileImageName = "profile"
        postRyuuu.statusImageName = "yumaYoutube"
        postRyuuu.numLikes = 23000
        postRyuuu.numComments = 72
        postRyuuu.numShares = 3
        
        
        let postTyrion = Post()
        postTyrion.name = "Tyrion Chiang"
        postTyrion.statusText = "I feel I fell in love with WuDan"
        postTyrion.profileImageName = "tyrion"
        postTyrion.statusImageName = "tyrion_status"
        postTyrion.numLikes = 520
        postTyrion.numComments = 3
        postTyrion.numShares = 0
        
        posts.append(postRyuuu)
        posts.append(postTyrion)
        
        navigationItem.title = "Facebook Feed"
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: CellId)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCellWithReuseIdentifier(CellId, forIndexPath: indexPath) as! FeedCell
        
        feedCell.post = posts[indexPath.item]
        
        if let name = posts[indexPath.item].name{
            feedCell.nameLabel.text = name
        }
        return feedCell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let statusText = posts[indexPath.item].statusText{
            
            let rect = NSString(string: statusText).boundingRectWithSize(CGSizeMake(view.frame.width, 1000), options: NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24  + 8 + 44

            
            return CGSizeMake(view.frame.width, rect.height + knownHeight + 24)
        }
        
        return CGSizeMake(view.frame.width, 1000)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}

class FeedCell: UICollectionViewCell{
    
    var post: Post?{
        didSet{
            
            if let name = post?.name{
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName:UIFont.boldSystemFontOfSize(14)])
                
                attributedText.appendAttributedString(NSAttributedString(string: "\n7 hrs  •  ", attributes: [NSFontAttributeName:UIFont.boldSystemFontOfSize(12), NSForegroundColorAttributeName: UIColor.rgb(155, green: 161, blue: 161)]))
                
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
            if let statusImageName = post?.statusImageName{
                statusImageView.image = UIImage(named: statusImageName)
            }
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
        imageView.image = UIImage(named: "profile")
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
        imageView.image = UIImage(named: "yumaYoutube")
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
        label.text = "330 comments  3 shards"
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
}
extension String{
    static func countLabelNumToString(num:Int) -> String{
        var numString = ""
        
        if num > 0{
            
            var point = 0
            
            if num >= 1000000000{
                point = (num / 100000000) % 10
                
                if point != 0{
                    numString = "\(num / 1000000000).\(point)G"
                }else{
                    numString = "\(num / 1000000000)G"
                }
                
            }else if num >= 1000000{
                point = (num / 100000) % 10
                
                if point != 0{
                    numString = "\(num / 1000000).\(point)M"
                }else{
                    numString = "\(num / 1000000)M"
                }
                
            }else if num >= 1000{
                point = (num / 100) % 10
                
                if point != 0{
                    numString = "\(num / 1000).\(point)K"
                }else{
                    numString = "\(num / 1000)K"
                }
                
            }else{
                numString = "\(num)"
            }
            
            

        }
        
        
        return numString
    }
}


extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
        
    }
}


extension UIView{
    
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerate(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
}