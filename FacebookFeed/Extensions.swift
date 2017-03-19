//
//  Extensions.swift
//  FacebookFeed
//
//  Created by Chiang Chuan on 7/14/16.
//  Copyright © 2016 Chiang Chuan. All rights reserved.
//

import Foundation
import UIKit


extension String{
    static func countLabelNumToString(_ num:Int) -> String{
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
    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
        
    }
}


extension UIView{
    
    func addConstraintsWithFormat(_ format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
}
