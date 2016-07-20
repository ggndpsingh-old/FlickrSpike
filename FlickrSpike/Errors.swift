//
//  Errors.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 19/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import Foundation


// -------------------------------------------------------------------------------------------------------
//MARK:
// MARK :- Errors
// -------------------------------------------------------------------------------------------------------

struct ErrorStrings {
    
    static let General                  = NSLocalizedString("Could not complete request. Try Again.", comment: "General error message")
    static let NoInternet               = NSLocalizedString("No Internet Connection.", comment: "Error for No Internet Connection")
    static let FlickrAPIOffline         = NSLocalizedString("Flickr is Offline! Try again later.", comment: "Error for Flickr API is Offline")
    static let InvalidAPIKey            = NSLocalizedString("Invalid Flickr Credentials", comment: "Error for a bad API Key. But the user doesnt need to the exact error.")
    static let ServiceUnavailable       = NSLocalizedString("Flickr Service Unavailable", comment: "Error for Flickr Service Unavailable")
    static let BadURL                   = NSLocalizedString("Invalid Search", comment: "Error for a bad search URL")
    
    static let FailedToLaodPhotos       = NSLocalizedString("Failed to Load Photos! Try Again.", comment: "Error for Username is too short")
    static let FailedToPerformSearch    = NSLocalizedString("Failed to Perform Search! Try Again.", comment: "Error for Password is too short")
    
}

    enum Error: Int {
        
        //Flickr API Errors
        case NoInternet             = -1009
        case FlickrAPIOffline       = 10
        case InvalidAPIKey          = 100
        case ServiceUnavailable     = 105
        case BadURL                 = 116
        
        //Custom Error Codes
        case FailedToLaodPhotos     = 9001
        case FailedToPerformSearch  = 9002
        
        
    }

    func showErrorMessage(forCode code: Int, completionHandler: ((completed: Bool) -> Void)?) {
        
        var message = ErrorStrings.General
        
        if let error = Error(rawValue: code) {
        
            switch error {
                
                case .NoInternet:
                    message = ErrorStrings.NoInternet
                
                case .FlickrAPIOffline:
                    message = ErrorStrings.FlickrAPIOffline
                
                case .InvalidAPIKey:
                    message = ErrorStrings.InvalidAPIKey
                    
                case .ServiceUnavailable:
                    message = ErrorStrings.ServiceUnavailable
                    
                case .BadURL:
                    message =  ErrorStrings.BadURL
                
                case .FailedToLaodPhotos:
                    message = ErrorStrings.FailedToLaodPhotos
                    
                case .FailedToPerformSearch:
                    message = ErrorStrings.FailedToPerformSearch
            }
        }
        
        Views.MessageView.show(withMessage: message, valid: false) { (completed) in
            completionHandler?(completed: true)
        }
    }
