//
//  FlickrPhotoTableHeaderView.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 18/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit


class FlickrPhotoTableHeaderView: BaseView {
    
    //MARK: Data
    var flickrPhoto: FlickrPhoto? {
        didSet {
            if let name = flickrPhoto?.ownerName {
                usernameLabel.text = name
            }
        }
    }
    
    
    //MARK: Views
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton(type: UIButtonType.detailDisclosure)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(Images.OptionsButtonImage, for: [])
        return button
    }()
    
    let separator: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0.1)
        return view
    }()
    
    
    override func setupViews() {
        
        backgroundColor = UIColor.white()
        
        addSubview(separator)
        separator.heightAnchor.constraint   (equalToConstant: 1 / MainScreen.Scale)     .isActive = true
        separator.topAnchor.constraint      (equalTo: topAnchor)                        .isActive = true
        separator.leftAnchor.constraint     (equalTo: leftAnchor)                       .isActive = true
        separator.rightAnchor.constraint    (equalTo: rightAnchor)                      .isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.topAnchor.constraint      (equalTo: topAnchor)                    .isActive = true
        usernameLabel.bottomAnchor.constraint   (equalTo: bottomAnchor)                 .isActive = true
        usernameLabel.leftAnchor.constraint     (equalTo: leftAnchor, constant: 20)     .isActive = true
        usernameLabel.rightAnchor.constraint    (equalTo: rightAnchor, constant: -70)   .isActive = true
        
        addSubview(optionsButton)
        optionsButton.rightAnchor.constraint    (equalTo: rightAnchor, constant: -10)   .isActive = true
        optionsButton.heightAnchor.constraint   (equalToConstant: 50)                   .isActive = true
        optionsButton.widthAnchor.constraint    (equalToConstant: 50)                   .isActive = true
        optionsButton.centerYAnchor.constraint  (equalTo: centerYAnchor)                .isActive = true
    }
    
}