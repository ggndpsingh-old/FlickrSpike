//
//  FlickrPhotoTableViewCell.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 18/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit

class FlickrPhotoTableViewCell: BaseTableCell {
    
    var tableView: FlickrPhotoTableView?
    
    
    lazy var longTap: UILongPressGestureRecognizer = {
        let lt = UILongPressGestureRecognizer()
        lt.addTarget(self, action: #selector(showImageOptions))
        return lt
    }()
    
    
    //MARK: Data
    var flickrPhoto: FlickrPhoto? {
        didSet {
            if let urlString = flickrPhoto?.imageUrl {
                photoView.loadImageUsingCache(withUrlString: urlString) { completed in
                    self.photoView.addGestureRecognizer(self.longTap)
                }
            }
        }
    }
    
    //MARK: Views
    let photoView: UIImageView = {
        let pv = UIImageView(frame: CGRect.zero)
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.contentMode = .scaleAspectFill
        pv.clipsToBounds = true
        pv.isUserInteractionEnabled = true
        return pv
    }()
    
    
    //MARK: Setup Views
    override func setupViews() {
        
        addSubview(photoView)
        photoView.leftAnchor.constraint     (equalTo: leftAnchor)           .isActive = true
        photoView.rightAnchor.constraint    (equalTo: rightAnchor)          .isActive = true
        photoView.topAnchor.constraint      (equalTo: topAnchor)            .isActive = true
        photoView.bottomAnchor.constraint   (equalTo: bottomAnchor)         .isActive = true
        photoView.heightAnchor.constraint   (equalTo: photoView.widthAnchor).isActive = true
        
        
    }
    
    func showImageOptions() {
        tableView?.showImagesOptions(forFlickrPhoto: flickrPhoto!, andImage: photoView.image!)
    }
    
}
