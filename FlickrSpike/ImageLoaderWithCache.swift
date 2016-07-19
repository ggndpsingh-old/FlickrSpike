//
//  ImageLoaderWithCache.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 19/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit


//----------------------------------------------------------------------------------------
//MARK:
//MARK: UIImage Loader with Cache
//----------------------------------------------------------------------------------------

/*
    
    We use a tags system to make sure images dont flickr/change when scrolling the views
    Each UIImage View is assigned a Tag from their IndexPath
    And each image load request is given a Tag of their own
    If both tags match, only then the photo is assigned to a UIImageView
 
 */


//Initlialize Image Cache
let imageCache = Cache<AnyObject, UIImage>()



//Image Loading extension
extension UIImageView {
    
    func loadImageUsingCache(withUrlString string: String, andTag tag: Int, completionHandler: ((completed: Bool) ->())? ) {
        
        //Start with remove the old image from the reused cell
        self.image = nil
        
        //First look in the Cache, if the image has been previously downloaded
        if let cachedImage = imageCache.object(forKey: string) {
            
            //Match Tags before assigning Image to UIImageView
            if tag == self.tag {
                self.image = cachedImage
                completionHandler?(completed: true)
            }
            return
        }
        
        //if Image on not found in the Cache, download it asynchrously
        let url = URL(string: string)
        URLSession.shared().dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                if let data = data {
                    
                    //If image is successfully downloaded, add it to Cache
                    let image = UIImage(data: data)
                    imageCache.setObject(image!, forKey: string)
                    
                    //Match tags before assigning Image to UIImageView
                    if tag == self.tag {
                        self.image = image
                        completionHandler?(completed: true)
                    }
                }
            }
            
        }).resume()
    }
}
