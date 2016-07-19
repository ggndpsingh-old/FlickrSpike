//
//  FlickrPhotoTableViewCell.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 18/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit

class FlickrPhotoTableViewCell: BaseTableCell {
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Data
    //----------------------------------------------------------------------------------------
    var flickrPhoto: FlickrPhoto? {
        didSet {
            if let urlString = flickrPhoto?.imageUrl {
                if let section = self.indexPath?.section {
                    photoView.tag = section
                    photoView.loadImageUsingCache(withUrlString: urlString, andTag: section) { completed in
                        self.photoView.addGestureRecognizer(self.longTap)
                    }
                }
            }
        }
    }
    
    var indexPath: IndexPath? {
        didSet {
            photoView.tag = indexPath!.section
        }
    }
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Parent Table View
    //----------------------------------------------------------------------------------------
    var tableView: FlickrPhotoTableView?
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: UI Elements
    //----------------------------------------------------------------------------------------
    lazy var longTap: UILongPressGestureRecognizer = {
        let lt = UILongPressGestureRecognizer()
        lt.addTarget(self, action: #selector(showImageOptions(recognizer:)))
        return lt
    }()
    
    let photoView: UIImageView = {
        let pv = UIImageView(frame: CGRect.zero)
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.contentMode = .scaleAspectFill
        pv.clipsToBounds = true
        pv.isUserInteractionEnabled = true
        return pv
    }()
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Setup Views
    //----------------------------------------------------------------------------------------
    override func setupViews() {
        
        addSubview(photoView)
        photoView.leftAnchor.constraint     (equalTo: leftAnchor)           .isActive = true
        photoView.rightAnchor.constraint    (equalTo: rightAnchor)          .isActive = true
        photoView.topAnchor.constraint      (equalTo: topAnchor)            .isActive = true
        photoView.bottomAnchor.constraint   (equalTo: bottomAnchor)         .isActive = true
        photoView.heightAnchor.constraint   (equalTo: photoView.widthAnchor).isActive = true
        
        
    }
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Method for Image Options Action Sheet
    //----------------------------------------------------------------------------------------
    func showImageOptions(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            tableView?.showImagesOptions(forFlickrPhoto: flickrPhoto!, atIndexPath: indexPath!)
        case .changed:
            break
        case .ended:
            break
            
        case .cancelled:
            break
        case .failed:
            break
        default:
            break
        }
    }
    
}
