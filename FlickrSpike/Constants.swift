//
//  Constants.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 17/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit


//----------------------------------------------------------------------------------------
//MARK:
//MARK: Flickr API
//----------------------------------------------------------------------------------------
struct FlickrAPI {
    static let Key              = "df0351148fbb8b07bcbe35fb49899313"
    static let Secret           = "f5663bb7cd86f419"
    
    static let SearchBaseUrl    = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Key)"
    static let RecentBaseUrl    = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(Key)"
    static let UserBaseUrl      = "https://api.flickr.com/services/rest/?method=flickr.people.getPhotos&api_key=\(Key)"
    static let Arguments        = "tag_mode=all&format=json&nojsoncallback=1&extras=owner_name,date_upload,date_taken,tags,views"
    
    static let ImagesPerPage    = 20
    
    static let SafeSearch       = SafeArguments.Safe
    
    enum SafeArguments: Int {
        case Safe       = 1
        case Moderate   = 2
        case Restricted = 3
    }
    
    enum Sort: String {
        case DateTaken      = "date-taken-desc"
        case DatePublished  = "date-posted-desc"
    }
}


//----------------------------------------------------------------------------------------
//MARK:
//MARK: Screen Constants
//----------------------------------------------------------------------------------------
struct MainScreen {
    static let Size  = UIScreen.main().bounds
    static let Scale = UIScreen.main().scale
}


//----------------------------------------------------------------------------------------
//MARK:
//MARK: Images
//----------------------------------------------------------------------------------------
struct Images {
    static let OptionsButtonImage       = UIImage(named: "icon-options")
    static let FeedButtonImage          = UIImage(named: "icon-feed")
    static let CollectionButtonImage    = UIImage(named: "icon-collection")
}


//----------------------------------------------------------------------------------------
//MARK:
//MARK: Views
//----------------------------------------------------------------------------------------
struct Views {
    static let MessageView = ErrorMessageView()
}
