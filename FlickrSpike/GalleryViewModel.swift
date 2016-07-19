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
    
    func fetchFailed(withError error: Int?)
    
    func fetchCompleted(withPhotos photos: [FlickrPhoto])
    func searchCompleted(withPhotos photos: [FlickrPhoto], forSearchString searchString: String)

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
    func fetchRecentImagesFromFlickr(atPage page:  Int, sortedBy sort: FlickrAPI.Sort) {
        
        //Show loading spinner on View Controller
        delegate?.showProcessing()
        
        //Construct fetch Url
        let urlString = "\(FlickrAPI.RecentBaseUrl)&per_page=\(FlickrAPI.ImagesPerPage)&page=\(page)&\(FlickrAPI.Arguments)&safe_search=\(FlickrAPI.SafeSearch.rawValue)&sort=\(sort.rawValue)"
        
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
                self.delegate?.hideProcessing()
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
    //MARK: Search Images from Flickr
    //----------------------------------------------------------------------------------------
    func searchflickrForTags(inString string: String, onPage page: Int, sortedBy sort: FlickrAPI.Sort) {
        
        //Show loading spinner on View Controller
        delegate?.showProcessing()
        
        //Create a Comma Separted string
        let tags = string.components(separatedBy: .whitespaces).joined(separator: ",").lowercased()
        
        //Construct Search Url
        let urlString = "\(FlickrAPI.SearchBaseUrl)&per_page=\(FlickrAPI.ImagesPerPage)&page=\(page)&tags=\(tags)&\(FlickrAPI.Arguments)&safe_search=\(FlickrAPI.SafeSearch.rawValue)&sort=\(sort.rawValue)"
        
        //Create URL
        let url = URL(string: urlString)!
        
        //Perform Search
        FlickrServices.fetchPhotosFromFlicr(withUrl: url) { (data, response, error) in
            
            //Stop loading if error occurs
            if error != nil {
                self.delegate?.hideProcessing()
                if let code = error?.code {
                    self.delegate?.fetchFailed(withError: code)
                }
                return
            }
            
            //Extract Photos from Result
            self.extractPhotos(fromData: data!) { photos in
                self.delegate?.searchCompleted(withPhotos: photos, forSearchString: string)
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
                        self.delegate?.hideProcessing()
                        completionHandler(images: images)
                        
                        
                        //If Someting goes wrong along the way, send error message
                    } else {
                        
                        self.delegate?.fetchFailed(withError: Error.FailedToLaodPhotos.rawValue)
                        self.delegate?.hideProcessing()
                    }
                } else {
                    
                    self.delegate?.fetchFailed(withError: Error.FailedToLaodPhotos.rawValue)
                    self.delegate?.hideProcessing()
                }
            } else {
                
                self.delegate?.fetchFailed(withError: Error.FailedToLaodPhotos.rawValue)
                self.delegate?.hideProcessing()
            }
        } else {
            
            self.delegate?.fetchFailed(withError: Error.FailedToLaodPhotos.rawValue)
            self.delegate?.hideProcessing()
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
