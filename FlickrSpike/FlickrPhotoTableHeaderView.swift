//
//  FlickrPhotoTableHeaderView.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 18/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit


class FlickrPhotoTableHeaderView: BaseView {
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Data
    //----------------------------------------------------------------------------------------
    var flickrPhoto: FlickrPhoto? {
        didSet {
            if let name = flickrPhoto?.ownerName {
                usernameButton.setTitle(name, for: [])
            }
        }
    }
    
    var indexPath: IndexPath?
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Parent Table View
    //----------------------------------------------------------------------------------------
    var tableView: FlickrPhotoTableView?
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: UI Elements
    //----------------------------------------------------------------------------------------
    lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.darkGray(), for: [])
        button.addTarget(self, action: #selector(showUserPhotos), for: .touchUpInside)
        return button
    }()
    
    lazy var optionsButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Images.OptionsButtonImage, for: [])
        button.addTarget(self, action: #selector(showImageOptions), for: .touchUpInside)
        return button
    }()
    
    let separator: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0.1)
        return view
    }()
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Setup Views
    //----------------------------------------------------------------------------------------
    override func setupViews() {
        
        backgroundColor = UIColor.white()
        
        //Separator
        addSubview(separator)
        separator.heightAnchor.constraint   (equalToConstant: 1 / MainScreen.Scale)     .isActive = true
        separator.topAnchor.constraint      (equalTo: topAnchor)                        .isActive = true
        separator.leftAnchor.constraint     (equalTo: leftAnchor)                       .isActive = true
        separator.rightAnchor.constraint    (equalTo: rightAnchor)                      .isActive = true
        
        //Username Label
        addSubview(usernameButton)
        usernameButton.topAnchor.constraint      (equalTo: topAnchor)                    .isActive = true
        usernameButton.bottomAnchor.constraint   (equalTo: bottomAnchor)                 .isActive = true
        usernameButton.leftAnchor.constraint     (equalTo: leftAnchor, constant: 20)     .isActive = true
        usernameButton.rightAnchor.constraint    (equalTo: rightAnchor, constant: -70)   .isActive = true
        
        //Options Button
        addSubview(optionsButton)
        optionsButton.rightAnchor.constraint    (equalTo: rightAnchor, constant: -10)   .isActive = true
        optionsButton.heightAnchor.constraint   (equalToConstant: 50)                   .isActive = true
        optionsButton.widthAnchor.constraint    (equalToConstant: 50)                   .isActive = true
        optionsButton.centerYAnchor.constraint  (equalTo: centerYAnchor)                .isActive = true
    }
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Method for Image Options Action Sheet
    //----------------------------------------------------------------------------------------
    func showImageOptions() {
        tableView?.showImagesOptions(forFlickrPhoto: flickrPhoto!, atIndexPath: indexPath!)
    }
    
    func showUserPhotos() {
        if let user = flickrPhoto?.ownerId, username = flickrPhoto?.ownerName {
            tableView?.showUserPhotos(forUser: user, withUsername: username)
        }
    }
    
}
