//
//  MenuCell.swift
//  FlickrImage
//
//  Created by Gagandeep Singh on 11/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit

class MenuCell: BaseCollectionCell {
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: UI Elements
    //----------------------------------------------------------------------------------------
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = Images.FeedButtonImage?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.lightGray()
        return iv
    }()
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Behavior
    //----------------------------------------------------------------------------------------
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? .menuBarTint() : .lightGray()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? .menuBarTint() : .lightGray()
        }
    }
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Setup Views
    //----------------------------------------------------------------------------------------
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}
