//
//  GalleryViewModel.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 18/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import Foundation

public protocol GalleryViewModelDelegate: class {
    
}

class GalleryViewModel {
    
    //MARK: Variables
    var delegate: GalleryViewModelDelegate?
    
    //MARK: Init
    init(delegate: GalleryViewModelDelegate) {
        self.delegate = delegate
    }
    
    //MARK: Fetch Recent Images from Flickr
    func fetchRecentImagesFromFlickr(completionHandler: (images: [FlickrPhoto]?, error: NSError?) -> ()) {
        
        var images = [FlickrPhoto]()
        
        let urlString = "\(FlickrAPI.RecentBaseUrl)&per_page=\(FlickrAPI.ImagesPerPage)&page=\(1)&tags=&format=json&nojsoncallback=1&extras=owner_name,date_upload,tags,views"
        print(urlString)
        
        let request = URLRequest(url: URL(string: urlString)!)
        
        URLSession.shared().dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                completionHandler(images: nil, error: error)
                return
            }
            
            if let result = String(data: data!, encoding: String.Encoding.utf8) {
                if let list = self.convertJsonStringToDictionary(string: result) {
                    if let photosList = list["photos"] as? NSDictionary {
                        if let photos = photosList["photo"] as? NSArray {
                            for photo in photos {
                                if photo is NSDictionary {
                                    let flickrPhoto = FlickrPhoto(withFlickrPhoto: photo as! NSDictionary)
                                    images.append(flickrPhoto)
                                }
                            }
                            completionHandler(images: images, error: nil)
                        }
                    }
                }
            }
        }.resume()
    }
    
    
    
    
    func convertJsonStringToDictionary(string: String) -> [String:AnyObject]? {
        
        if let data = string.data(using: String.Encoding.utf8) {
            
            do {
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch let error as NSError {
                print(error.description)
            }
        }
        return nil
    }
}
