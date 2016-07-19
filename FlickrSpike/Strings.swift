//
//  Strings.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 19/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import Foundation


struct Strings {
    
    static let SearchTags   = NSLocalizedString("Searcg Tags", comment: "Placeholder for search bar input")
    static let PhotoOptions = NSLocalizedString("Photo Options", comment: "Title for Photo Options actionsheet")
    static let SavePhoto    = NSLocalizedString("Save Photo", comment: "Title for Save Photo in Photo Gallery button")
    static let OpenInSafari = NSLocalizedString("Open in Safari", comment: "Title for Open Photo in Safari button")
    static let ShareByEmail = NSLocalizedString("Share by Email", comment: "Title for  Share Photo by Email button")
    static let Views        = NSLocalizedString("Views", comment: "To tell the user, how many views a photo has reveived")
    static let Tags         = NSLocalizedString("Tags", comment: "Header to tell user that following are the tags for a photo")
    
    static func ShowingAllPhotos(withCount count: Int, forTags tags: String) -> String {
        return String(format: NSLocalizedString("Showing all %i Photos for %@", comment: "Gallery detail for photos being shown for performed search e.g Showing all photos for cats"), count, tags)
    }
    
    static func ShowingAllRecentPhotos(withCount count: Int) -> String {
        return String(format: NSLocalizedString("Showing %i Recent Photos", comment: "Gallery detail for recent photos being shown"), count)
    }
    
}
