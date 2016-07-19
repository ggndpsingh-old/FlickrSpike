//
//  FlickrService.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 19/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import Foundation


struct FlickrServices {
    
    
    static func fetchPhotosFromFlicr(withUrl url: URL, completionHandler: (data: Data?, response: URLResponse?, error: NSError?) -> ()) {
        
        let request = URLRequest(url: url)
        
        
        URLSession.shared().dataTask(with: request) { (data, response, error) in
            completionHandler(data: data, response: response, error: error)
        }.resume()
        
    }
    
    
}
