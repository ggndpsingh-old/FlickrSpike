//
//  FlickrPhotoDataCell.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 18/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit

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
    
    let timeLabel: UILabel = {
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
        timeLabel.removeFromSuperview()
        
        
        if let views = flickrPhoto?.views {
            viewsLabel = createLabel(withAddedBoldString: "\(Strings.Views):", toString: views, withFontSize: 13)
        }
        
        if let tags = flickrPhoto?.tags {
            let separated = tags.components(separatedBy: .whitespaces).joined(separator: ", ")
            tagsLabel = createLabel(withAddedBoldString: "\(Strings.Tags):", toString: separated, withFontSize: 13)
        }
        
        if let date = flickrPhoto?.published {
            timeLabel.text = date.longFormat()
        }
        
        
        //Add labels to view with constraints
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
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Method to create String with Bold Initial string
    //----------------------------------------------------------------------------------------
    func createLabel(withAddedBoldString boldString: String, toString string: String, withFontSize fontSize: CGFloat) -> UILabel {
        
        let boldAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: fontSize)]
        let attributedString = NSMutableAttributedString(string: "\(boldString) \(string)")
        let range = NSRange(location: 0, length: boldString.characters.count)
        attributedString.addAttributes(boldAttribute, range: range)
        
        let label: UILabel = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray()
        label.lineBreakMode = .byWordWrapping
        label.attributedText = attributedString
        
        return label
    }
}
