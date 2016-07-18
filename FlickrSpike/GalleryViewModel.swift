//
//  GalleryViewModel.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 18/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import Foundation

public protocol GalleryViewModelDelegate: class {
    
    func showProcessing()
    func hideProcessing()
}

class GalleryViewModel {
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Variables
    //----------------------------------------------------------------------------------------
    var delegate: GalleryViewModelDelegate?
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Initializers
    //----------------------------------------------------------------------------------------
    init(delegate: GalleryViewModelDelegate) {
        self.delegate = delegate
    }
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Fetch Recent Images from Flickr
    //----------------------------------------------------------------------------------------
    func fetchRecentImagesFromFlickr(atPage page:  Int, completionHandler: (images: [FlickrPhoto]?, error: NSError?) -> ()) {
        
        //Show loading spinner on View Controller
        delegate?.showProcessing()
        
        var images = [FlickrPhoto]()
        
        
        //Construct fetch Url
        let urlString = "\(FlickrAPI.RecentBaseUrl)&per_page=\(FlickrAPI.ImagesPerPage)&page=\(page)&\(FlickrAPI.Arguments)&safe_search=\(FlickrAPI.SafeSearch.rawValue)"
        
        
        //Create URL Request
        let request = URLRequest(url: URL(string: urlString)!)
        
        
        //Perform Fetch
        URLSession.shared().dataTask(with: request) { (data, response, error) in
            
            //Stop loading if error occurs
            if error != nil {
                self.delegate?.hideProcessing()
                completionHandler(images: nil, error: error)
                return
            }
            
            //Extract Photos from Result
            if let result = String(data: data!, encoding: String.Encoding.utf8) {
                if let list = self.convertJsonStringToDictionary(string: result) {
                    if let photosList = list["photos"] as? NSDictionary {
                        if let photos = photosList["photo"] as? NSArray {
                            for photo in photos {
                                let flickrPhoto = FlickrPhoto(withFlickrPhoto: photo as! NSDictionary)
                                
                                if let url = flickrPhoto.imageUrl {
                                    if imageCache.object(forKey: url) == nil {
                                        images.append(flickrPhoto)
                                    }
                                }
                            }
                            self.delegate?.hideProcessing()
                            completionHandler(images: images, error: nil)
                        } else {
                            completionHandler(images: nil, error: nil)
                            self.delegate?.hideProcessing()
                        }
                    } else {
                        completionHandler(images: nil, error: nil)
                        self.delegate?.hideProcessing()
                    }
                } else {
                    completionHandler(images: nil, error: nil)
                    self.delegate?.hideProcessing()
                }
            } else {
                completionHandler(images: nil, error: nil)
                self.delegate?.hideProcessing()
            }
        }.resume()
    }
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Search Images from Flickr
    //----------------------------------------------------------------------------------------
    func searchflickrForTags(inString string: String, onPage page: Int, completionHandler: (searchString: String, images: [FlickrPhoto]?, error: NSError?) -> ()) {
        
        //Show loading spinner on View Controller
        delegate?.showProcessing()
        
        var images = [FlickrPhoto]()
        
        //Create a Comma Separted string
        let tags = string.components(separatedBy: .whitespaces).joined(separator: ",").lowercased()
        
        //Construct Search Url
        let urlString = "\(FlickrAPI.SearchBaseUrl)&per_page=\(FlickrAPI.ImagesPerPage)&page=\(page)&tags=\(tags)&\(FlickrAPI.Arguments)&safe_search=\(FlickrAPI.SafeSearch.rawValue)"
        
        //Create URL Request
        let request = URLRequest(url: URL(string: urlString)!)
        
        //Perform Search
        URLSession.shared().dataTask(with: request) { (data, response, error) in
            
            //Stop loading if error occurs
            if error != nil {
                self.delegate?.hideProcessing()
                completionHandler(searchString: string, images: nil, error: error)
                return
            }
            
            //Extract Photos from Result
            if let result = String(data: data!, encoding: String.Encoding.utf8) {
                if let list = self.convertJsonStringToDictionary(string: result) {
                    if let photosList = list["photos"] as? NSDictionary {
                        if let photos = photosList["photo"] as? NSArray {
                            for photo in photos {
                                let flickrPhoto = FlickrPhoto(withFlickrPhoto: photo as! NSDictionary)
                                if let url = flickrPhoto.imageUrl {
                                    if imageCache.object(forKey: url) == nil {
                                        images.append(flickrPhoto)
                                    }
                                }
                            }
                            self.delegate?.hideProcessing()
                            completionHandler(searchString: string, images: images, error: nil)
                        } else {
                            self.delegate?.hideProcessing()
                            completionHandler(searchString: string, images: images, error: nil)
                        }
                    } else {
                        self.delegate?.hideProcessing()
                        completionHandler(searchString: string, images: images, error: nil)
                    }
                } else {
                    self.delegate?.hideProcessing()
                    completionHandler(searchString: string, images: images, error: nil)
                }
            } else {
                self.delegate?.hideProcessing()
                completionHandler(searchString: string, images: images, error: nil)
            }
        }.resume()
    }
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Convert JSON String to Dictionary
    //----------------------------------------------------------------------------------------
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
