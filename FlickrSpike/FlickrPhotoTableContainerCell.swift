//
//  FlickrPhotoTableContainerCell.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 18/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit


/*
    
    Container cell for Split View that contains Table View
 
 */


class FlickrPhotoTableContainerCell: BaseCollectionCell {
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Data
    //----------------------------------------------------------------------------------------
    var flickrPhotos: [FlickrPhoto]? {
        didSet {
            tableView.flickrPhotos = flickrPhotos
        }
    }
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: UI Elements
    //----------------------------------------------------------------------------------------
    var tableView: FlickrPhotoTableView = {
        let tv = FlickrPhotoTableView(frame: CGRect.zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Setup Views
    //----------------------------------------------------------------------------------------
    override func setupViews() {
        
        addSubview(tableView)
        tableView.leftAnchor.constraint     (equalTo: leftAnchor)   .isActive = true
        tableView.rightAnchor.constraint    (equalTo: rightAnchor)  .isActive = true
        tableView.topAnchor.constraint      (equalTo: topAnchor)    .isActive = true
        tableView.bottomAnchor.constraint   (equalTo: bottomAnchor) .isActive = true
    }
}


