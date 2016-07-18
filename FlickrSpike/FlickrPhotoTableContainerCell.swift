//
//  FlickrPhotoTableContainerCell.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 18/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit


class FlickrPhotoTableContainerCell: BaseCollectionCell {
    
    //MARK: Data
    var flickrPhotos: [FlickrPhoto]? {
        didSet {
            tableView.flickrPhotos = flickrPhotos
        }
    }
    
    
    //MARK: Views
    var tableView: FlickrPhotoTableView = {
        let tv = FlickrPhotoTableView(frame: CGRect.zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func setupViews() {
        
        addSubview(tableView)
        tableView.leftAnchor.constraint     (equalTo: leftAnchor)   .isActive = true
        tableView.rightAnchor.constraint    (equalTo: rightAnchor)  .isActive = true
        tableView.topAnchor.constraint      (equalTo: topAnchor)    .isActive = true
        tableView.bottomAnchor.constraint   (equalTo: bottomAnchor) .isActive = true
    }
    
    func handleReload() {
        flickrPhotos = [FlickrPhoto]()
    }
    
}


