//
//  Extensions.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 18/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit

//----------------------------------------------------------------------------------------
//MARK:
//MARK: Date
//----------------------------------------------------------------------------------------
extension Date {
    func longFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, YYYY hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    func dateOnlyFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, YYYY"
        return dateFormatter.string(from: self)
    }
}




//----------------------------------------------------------------------------------------
//MARK:
//MARK: UIImage
//----------------------------------------------------------------------------------------

//MARK:- Cache
let imageCache = Cache<AnyObject, UIImage>()
extension UIImageView {
    
    func loadImageUsingCache(withUrlString string: String, completionHandler: ((completed: Bool) ->())? ) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: string) {
            self.image = cachedImage
            completionHandler?(completed: true)
            return
        }
        
        let url = URL(string: string)
        URLSession.shared().dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                
                let image = UIImage(data: data!)
                imageCache.setObject(image!, forKey: string)
                
                self.image = image
                completionHandler?(completed: true)
            }
            
        }).resume()
    }
}



//----------------------------------------------------------------------------------------
//MARK:
//MARK: UIColor
//----------------------------------------------------------------------------------------
extension UIColor {
    class func navBar() -> UIColor {
        return UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
    }
    
    class func menuBarTint() -> UIColor {
        return UIColor(red: 220/255,  green: 73/255, blue: 55/255,  alpha: 1)
    }
    
    class func buttonBlue() -> UIColor {
        return UIColor(red: 42/255,  green: 163/255, blue: 239/255,  alpha: 1)
    }
    
    class func validGreen() -> UIColor {
        return UIColor(red: 50/255,  green: 180/255, blue: 30/255,  alpha: 1)
    }
    
    class func errorRed() -> UIColor {
        return UIColor(red: 210/255, green: 0/255,   blue: 30/255,  alpha: 1)
    }
    
    class func separator() -> UIColor {
        return UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    }
}


//----------------------------------------------------------------------------------------
//MARK:
//MARK: String
//----------------------------------------------------------------------------------------
extension String {
    
    //To trim while spaces from left and right of a string
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    //To condense white spaces wihtin the string
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespaces)
        let filtered = components.filter({!$0.isEmpty})
        return filtered.joined(separator: " ")
    }
    
}
