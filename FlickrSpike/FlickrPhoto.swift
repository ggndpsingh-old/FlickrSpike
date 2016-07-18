//
//  FlickrPhoto.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 18/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import Foundation

class FlickrPhoto: NSObject {
    
    
    //MARK: Properties
    var id          : String?
    var title       : String?
    
    var ownerId     : String?
    var ownerName   : String?
    
    var imageUrl    : String?
    var flickrUrl   : String?
    
    var tags        : String?
    var views       : String?
    
    var published   : Date?
    
    
    //MARK: Initializers
    init(withFlickrPhoto photo: NSDictionary) {
        super.init()
        
        id          = photo["id"]           as? String
        title       = photo["title"]        as? String
        
        ownerId     = photo["owner"]        as? String
        ownerName   = photo["ownername"]    as? String
        
        tags        = photo["tags"]         as? String
        views       = photo["views"]        as? String
        
        if let timeStamp = photo["dateupload"] as? String {
            published = Date(timeIntervalSince1970: Double(Int(timeStamp)!))
        }
        
        createUrls(forFlickrPhoto: photo)
    }
    
    func createUrls(forFlickrPhoto photo: NSDictionary) {
        
        let farm    = photo["farm"]     as? Int
        let server  = photo["server"]   as? String
        let secret  = photo["secret"]   as? String
        
        if let farm = farm, server = server, id = id, secret = secret {
            
            imageUrl  = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_c.jpg"
            
            if let ownerId = ownerId {
                flickrUrl = "https://www.flickr.com/photos/\(ownerId)/\(id)"
            }
        }
    }
}
