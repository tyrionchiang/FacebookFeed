//
//  posts.swift
//  FacebookFeed
//
//  Created by Chiang Chuan on 7/14/16.
//  Copyright © 2016 Chiang Chuan. All rights reserved.
//

import Foundation


class Post{
    var name: String?
    var postTime: String?
    var statusText: String?
    var profileImageName: String?
    var statusImageName: String?
    var numLikes: Int?
    var numComments: Int?
    var numShares: Int?
    
    var statusImageUrl: String?
    
}

class  Posts {
    private let postsList: [Post]
    
    init(){
        let postRyuuu = Post()
        postRyuuu.name = "Ryuuu TV / 學日文看日本"
        postRyuuu.postTime = "July 14"
        postRyuuu.statusText = "台灣的朋友們，昨天的颱風還好嗎？看了幾則覺得這次颱風好恐怖的新聞⋯嫌だね。\n照片是我（ryu）今早看手機覺得很可愛的想說分享一下"
        postRyuuu.profileImageName = "profile"
        postRyuuu.statusImageName = "yumaYoutube"
        postRyuuu.numLikes = 12000
        postRyuuu.numComments = 72
        postRyuuu.numShares = 3
        postRyuuu.statusImageUrl = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/mark_zuckerberg_background.jpg"
        
        
        
        let postTyrion2 = Post()
        postTyrion2.name = "Tyrion Chiang"
        postTyrion2.postTime = "July 14"
        postTyrion2.statusText = "翩若驚鴻，婉若遊龍，榮曜秋菊，華茂春松"
        postTyrion2.profileImageName = "tyrion"
        postTyrion2.statusImageName = "IMG_0859"
        postTyrion2.numLikes = 13
        postTyrion2.numComments = 7
        postTyrion2.numShares = 0
        postTyrion2.statusImageUrl = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/steve_jobs_background.jpg"

        
        let postTyrion = Post()
        postTyrion.name = "Tyrion Chiang"
        postTyrion.postTime = "July 14"
        postTyrion.statusText = "LaLa~~~ La~~~"
        postTyrion.profileImageName = "tyrion"
        postTyrion.statusImageName = "tyrion_status"
        postTyrion.numLikes = 520
        postTyrion.numComments = 3
        postTyrion.numShares = 0
        postTyrion.statusImageUrl = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/gandhi_status.jpg"
        
        let postTyrion3 = Post()
        postTyrion3.name = "Tyrion Chiang"
        postTyrion3.postTime = "July 13"
        postTyrion3.statusText = "follow excellence, success will chase you"
        postTyrion3.profileImageName = "tyrion"
        postTyrion3.statusImageName = "tyrion_status"
        postTyrion3.numLikes = 3200000
        postTyrion3.numComments = 27
        postTyrion3.numShares = 0
        postTyrion3.statusImageUrl = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/gates_background.jpg"
        
        let postRyuuu1 = Post()
        postRyuuu1.name = "Ryuuu TV / 學日文看日本"
        postRyuuu1.postTime = "July 10"
        postRyuuu1.statusText = "水樹奈々　超好き"
        postRyuuu1.profileImageName = "profile"
        postRyuuu1.statusImageName = "yumaYoutube"
        postRyuuu1.numLikes = 1000000000
        postRyuuu1.numComments = 7050
        postRyuuu1.numShares = 80
        postRyuuu1.statusImageUrl = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/Tim+Cook.png"
        
        let postTyrion4 = Post()
        postTyrion4.name = "Tyrion Chiang"
        postTyrion4.postTime = "July 9"
        postTyrion4.statusText = "山人送主公"
        postTyrion4.profileImageName = "tyrion"
        postTyrion4.statusImageName = "tyrion_status"
        postTyrion4.numLikes = 2500
        postTyrion4.numComments = 6
        postTyrion4.numShares = 0
        postTyrion4.statusImageUrl = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/trump_background.jpg"
        
        
     

        
        postsList = [postRyuuu, postTyrion2, postTyrion, postTyrion3, postRyuuu1, postTyrion4]
    }

    func numberOfPosts() -> Int {
        return postsList.count
    }
    subscript(indexPath: NSIndexPath) -> Post{
        return postsList[indexPath.item]
    }
}