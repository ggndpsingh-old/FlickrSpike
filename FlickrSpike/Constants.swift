//
//  Constants.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 17/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit


//MARK: Flickr API
struct FlickrAPI {
    static let Key      = "df0351148fbb8b07bcbe35fb49899313"
    static let Secret   = "f5663bb7cd86f419"
    
    static let SearchBaseUrl    = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(FlickrAPI.Key)"
    static let RecentBaseUrl    = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(FlickrAPI.Key)"
}


//MARK: Screen Constants
struct MainScreen {
    static let Size  = UIScreen.main().bounds
    static let Scale = UIScreen.main().scale
}
