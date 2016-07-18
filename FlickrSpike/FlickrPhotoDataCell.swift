//
//  FlickrPhotoDataCell.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 18/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit

class FlickrPhotoDataCell: BaseTableCell {
    
    //MARK: Data
    var flickrPhoto: FlickrPhoto? {
        didSet {
            setupLabels()
        }
    }
    
    //MARK: Views
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
    
    let timeLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.lightGray()
        return label
    }()
    
    func setupLabels() {
        
        tagsLabel.text  = ""
        viewsLabel.text = ""
        
        if let views = flickrPhoto?.views {
            viewsLabel = createViewsLabel(with: views)
        }
        
        if let tags = flickrPhoto?.tags {
            tagsLabel = createTagsLabel(with: tags)
        }
        
        if let date = flickrPhoto?.published {
            timeLabel.text = date.longFormat()
        }
        
        addSubview(viewsLabel)
        viewsLabel.topAnchor.constraint     (equalTo: topAnchor, constant: 16)              .isActive = true
        viewsLabel.leftAnchor.constraint    (equalTo: leftAnchor, constant: 16)             .isActive = true
        viewsLabel.rightAnchor.constraint   (equalTo: rightAnchor, constant: -16)           .isActive = true
        viewsLabel.heightAnchor.constraint  (equalToConstant: 20)                           .isActive = true
        
        addSubview(tagsLabel)
        tagsLabel.topAnchor.constraint      (equalTo: viewsLabel.bottomAnchor, constant: 5) .isActive = true
        tagsLabel.bottomAnchor.constraint   (equalTo: bottomAnchor, constant: -60)          .isActive = true
        tagsLabel.leftAnchor.constraint     (equalTo: leftAnchor, constant: 16)             .isActive = true
        tagsLabel.rightAnchor.constraint    (equalTo: rightAnchor, constant: -16)           .isActive = true
        
        addSubview(timeLabel)
        timeLabel.bottomAnchor.constraint   (equalTo: bottomAnchor, constant: -20)          .isActive = true
        timeLabel.leftAnchor.constraint     (equalTo: leftAnchor, constant: 16)             .isActive = true
        timeLabel.widthAnchor.constraint    (equalToConstant: 160)                          .isActive = true
        timeLabel.heightAnchor.constraint   (equalToConstant: 20)                           .isActive = true
    }
    
    
    func createTagsLabel(with tags: String) -> UILabel {
        
        let joined = tags.components(separatedBy: .whitespaces).joined(separator: ", ")
        
        let boldAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 13)]
        
        let attributedString = NSMutableAttributedString(string: "Tags: \(joined)")
        let range = NSRange(location: 0, length: 5)
        
        attributedString.addAttributes(boldAttribute, range: range)
        
        let label: UILabel = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray()
        label.lineBreakMode = .byWordWrapping
        
        label.attributedText = attributedString
        
        return label
    }
    
    
    func createViewsLabel(with views: String) -> UILabel {
        
        let boldAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 13)]
        
        let attributedString = NSMutableAttributedString(string: "Views: \(views)")
        let range = NSRange(location: 0, length: 6)
        
        attributedString.addAttributes(boldAttribute, range: range)
        
        let label: UILabel = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray()
        label.lineBreakMode = .byWordWrapping
        
        label.attributedText = attributedString
        
        return label
    }
}
