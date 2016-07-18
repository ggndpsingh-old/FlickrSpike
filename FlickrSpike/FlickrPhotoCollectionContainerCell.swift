//
//  FlickrImageCollectionContainerCell.swift
//  FlickrImage
//
//  Created by Gagandeep Singh on 11/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit

class FlickrPhotoCollectionContainerCell: BaseCollectionCell {
    
    lazy internal var collectionView: FlickrPhotoCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = FlickrPhotoCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
    override func setupViews() {
        
        addSubview(collectionView)
        collectionView.leftAnchor.constraint    (equalTo: leftAnchor)   .isActive = true
        collectionView.rightAnchor.constraint   (equalTo: rightAnchor)  .isActive = true
        collectionView.topAnchor.constraint     (equalTo: topAnchor)    .isActive = true
        collectionView.bottomAnchor.constraint  (equalTo: bottomAnchor) .isActive = true
    }
}
