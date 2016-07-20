//
//  FlickrPhotoDataCell.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 18/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit


/*
    
    Table View cell that contins Photo Data
    Displays, Number of Views, tags, Date taken and Date published
 
 */


class FlickrPhotoDataCell: BaseTableCell {
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Data
    //----------------------------------------------------------------------------------------
    var flickrPhoto: FlickrPhoto? {
        didSet {
            setupLabels()
        }
    }
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: UI Elements
    //----------------------------------------------------------------------------------------
    var tagsLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var viewsLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let takenLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.lightGray()
        return label
    }()
    
    let publishedLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.lightGray()
        return label
    }()
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Setup Labels
    //----------------------------------------------------------------------------------------
    func setupLabels() {
        
        //Remove labels before each reuse of cell
        viewsLabel.removeFromSuperview()
        tagsLabel.removeFromSuperview()
        publishedLabel.removeFromSuperview()
        
        
        if let views = flickrPhoto?.views {
            viewsLabel = createLabel(withAddedBoldString: "\(Strings.Views):", toString: views, withFontSize: 13)
        }
        
        if let tags = flickrPhoto?.tags {
            let separated = tags.components(separatedBy: .whitespaces).joined(separator: ", ")
            tagsLabel = createLabel(withAddedBoldString: "\(Strings.Tags):", toString: separated, withFontSize: 13)
        }
        
        if let date = flickrPhoto?.taken {
            takenLabel.text = "\(Strings.Taken): \(date.longFormat())"
        }
        
        if let date = flickrPhoto?.published {
            publishedLabel.text = "\(Strings.Published): \(date.longFormat())"
        }
        
        
        //Views Label
        addSubview(viewsLabel)
        viewsLabel.topAnchor.constraint     (equalTo: topAnchor, constant: 16)              .isActive = true
        viewsLabel.leftAnchor.constraint    (equalTo: leftAnchor, constant: 16)             .isActive = true
        viewsLabel.rightAnchor.constraint   (equalTo: rightAnchor, constant: -16)           .isActive = true
        viewsLabel.heightAnchor.constraint  (equalToConstant: 20)                           .isActive = true
        
        //Tags Label
        addSubview(tagsLabel)
        tagsLabel.topAnchor.constraint      (equalTo: viewsLabel.bottomAnchor, constant: 5) .isActive = true
        tagsLabel.leftAnchor.constraint     (equalTo: leftAnchor, constant: 16)             .isActive = true
        tagsLabel.rightAnchor.constraint    (equalTo: rightAnchor, constant: -16)           .isActive = true
        
        //Date Taken Label
        addSubview(takenLabel)
        takenLabel.topAnchor.constraint     (equalTo: tagsLabel.bottomAnchor, constant: 10) .isActive = true
        takenLabel.leftAnchor.constraint    (equalTo: leftAnchor, constant: 16)             .isActive = true
        takenLabel.rightAnchor.constraint   (equalTo: rightAnchor, constant: -16)           .isActive = true
        takenLabel.heightAnchor.constraint  (equalToConstant: 20)                           .isActive = true
        
        //Date Published Label
        addSubview(publishedLabel)
        publishedLabel.topAnchor.constraint     (equalTo: takenLabel.bottomAnchor)          .isActive = true
        publishedLabel.leftAnchor.constraint    (equalTo: leftAnchor, constant: 16)             .isActive = true
        publishedLabel.rightAnchor.constraint   (equalTo: rightAnchor, constant: -16)           .isActive = true
        publishedLabel.bottomAnchor.constraint  (equalTo: bottomAnchor, constant: -20)          .isActive = true
        publishedLabel.heightAnchor.constraint  (equalToConstant: 20)                           .isActive = true
    }
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Prepare for Reuse
    //----------------------------------------------------------------------------------------
    override func prepareForReuse() {
        viewsLabel.attributedText = nil
        tagsLabel.attributedText = nil
        takenLabel.text = nil
        publishedLabel.text = nil
    }
}
