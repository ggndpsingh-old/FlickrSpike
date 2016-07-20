//
//  Strings.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 19/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import Foundation


//--------------------------------------------------------------------------------
//MARK:
//MARK: Localizable Strings
//--------------------------------------------------------------------------------
struct Strings {
    
    static let SearchTags               = NSLocalizedString("Search Tags",              comment: "Placeholder for search bar input")
    
    static let PhotoOptions             = NSLocalizedString("Photo Options",            comment: "Title for Photo Options actionsheet")
    
    static let SavePhoto                = NSLocalizedString("Save Photo",               comment: "Title for Save Photo in Photo Gallery button")
    
    static let OpenInSafari             = NSLocalizedString("Open in Safari",           comment: "Title for Open Photo in Safari button")
    
    static let ShareByEmail             = NSLocalizedString("Share by Email",           comment: "Title for  Share Photo by Email button")
    
    static let Views                    = NSLocalizedString("Views",                    comment: "To tell the user, how many views a photo has reveived")
    
    static let Tags                     = NSLocalizedString("Tags",                     comment: "Header to tell user that following are the tags for a photo")
    
    static let Taken                    = NSLocalizedString("Taken",                    comment: "Title for label that shows when a Photo was taken.")
    
    static let Published                = NSLocalizedString("Published",                comment: "Title for label that shows when a Photo was published.")
    
    static let PhotoSavedSuccessfuly    = NSLocalizedString("Photo Saved",              comment: "Message shown when a user successfuly saves a photo to the Photo Gallery")
    
    static let PhotoSaveFailed          = NSLocalizedString("Could not save photo",     comment: "Messagee shown when a user tries to save a photo to Photo Gallery but it fails")
    
    static let EmailSent                = NSLocalizedString("Email Sent",               comment: "Message shown when user successfully sends an email with a photo attatchment.")
    
    static let EmailCancelled           = NSLocalizedString("Email Cancelled",          comment: "Message shown when user cancels the sending of email with a photo attathments.")

    static let EmailFailed              = NSLocalizedString("Could not send Email",     comment: "Message show when an email with a photo attatchment failes to be sent.")
    
    static let NoPhotosFound            = NSLocalizedString("No Photos",                comment: "Message for when no photos are available to show")
    
    
    
    static func ShowingPhotos(withCount count: Int, forTags tags: String) -> String {
        return String(format: NSLocalizedString("Showing %i Photos for %@", comment: "Gallery detail for photos being shown for performed search e.g Showing all photos for cats"), count, tags)
    }
    
    static func ShowingRecentPhotos(withCount count: Int) -> String {
        return String(format: NSLocalizedString("Showing %i Recent Photos", comment: "Gallery detail for recent photos being shown"), count)
    }
    
}
