//
//  UserPhotosViewModel.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 19/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import Foundation


public protocol UserPhotosViewModelDelegate: class {
    
    func fetchFailed(withError error: Int?)
    func fetchCompleted(withPhotos photos: [FlickrPhoto])
    
}

class UserPhotosViewModel {
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Variables
    //----------------------------------------------------------------------------------------
    var delegate: UserPhotosViewModelDelegate?
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Initializers
    //----------------------------------------------------------------------------------------
    init(delegate: UserPhotosViewModelDelegate) {
        self.delegate = delegate
    }
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Fetch Recent Images from Flickr
    //----------------------------------------------------------------------------------------
    func fetchRecentImagesFromFlickr(forUser user: String, atPage page:  Int, sortedBy sort: FlickrAPI.Sort) {
        
        
        //Construct fetch Url
        let urlString = "\(FlickrAPI.UserBaseUrl)&per_page=\(FlickrAPI.ImagesPerPage)&page=\(page)&\(FlickrAPI.Arguments)&safe_search=\(FlickrAPI.SafeSearch.rawValue)&sort=\(sort.rawValue)&user_id=\(user)"
        
        //Create URL
        let url = URL(string: urlString)!
        
        
        
        //Perform Fetch
        FlickrServices.fetchPhotosFromFlicr(withUrl: url) { (data, response, error) in
            
            //Stop loading if error occurs
            if error != nil {
                print(error)
                if let code = error?.code {
                    self.delegate?.fetchFailed(withError: code)
                }
                return
            }
            
            //Extract Photos from Result
            self.extractPhotos(fromData: data!) { photos in
                self.delegate?.fetchCompleted(withPhotos: photos)
            }
            
        }
    }
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Extract Photos from Data
    //----------------------------------------------------------------------------------------
    func extractPhotos(fromData data: Data, completionHandler: (images: [FlickrPhoto]) -> ()) {
        
        var images = [FlickrPhoto]()
        
        //Convert Data to JSON String
        if let result = String(data: data, encoding: String.Encoding.utf8) {
            
            //Convert JSON String to NSDictionary
            if let list = self.convertJsonStringToDictionary(string: result) {
                
                //Extract Photos Dictionary
                if let photosList = list["photos"] as? NSDictionary {
                    if let photos = photosList["photo"] as? NSArray {
                        
                        for photo in photos {
                            //Convert each Photo Dictionary to a FlickrPhoto Model
                            let flickrPhoto = FlickrPhoto(withFlickrPhoto: photo as! NSDictionary)
                            
                            /*
                             Becase flickr gets a lot of photo uploads,
                             There is a possibility that by the time user reaches page 2 or 3 of the gallery,
                             some photos on page 1 would have been pushed to a position that would show up on page 2 or 3.
                             So, we check against Image Cache before adding an Image to the Data Source, to avoid repititions.
                             */
                            if let url = flickrPhoto.imageUrl {
                                if imageCache.object(forKey: url) == nil {
                                    images.append(flickrPhoto)
                                }
                            }
                        }
                        completionHandler(images: images)
                        
                        
                        //If Someting goes wrong along the way, send error message
                    } else {
                        
                        self.delegate?.fetchFailed(withError: Error.FailedToLaodPhotos.rawValue)
                    }
                } else {
                    
                    self.delegate?.fetchFailed(withError: Error.FailedToLaodPhotos.rawValue)
                }
            } else {
                
                self.delegate?.fetchFailed(withError: Error.FailedToLaodPhotos.rawValue)
            }
        } else {
            
            self.delegate?.fetchFailed(withError: Error.FailedToLaodPhotos.rawValue)
        }
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
