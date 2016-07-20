//
//  Helpers.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 20/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit





//----------------------------------------------------------------------------------------
//MARK:
//MARK: Convert JSON String to Dictionary
//----------------------------------------------------------------------------------------
func convertJsonStringToDictionary(string: String) -> [String:AnyObject]? {
    
    if let data = string.data(using: String.Encoding.utf8) {
        
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
        } catch let error as NSError {
            print(error.description)
        }
    }
    return nil
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






//----------------------------------------------------------------------------------------
//MARK:
//MARK: Method to create String with Bold Initial string
//----------------------------------------------------------------------------------------
func createAttributdString(withAddedBoldString boldString: String, toString string: String, withFontSize fontSize: CGFloat) -> AttributedString {
    
    let boldAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: fontSize)]
    let attributedString = NSMutableAttributedString(string: "\(boldString) \(string)")
    let range = NSRange(location: 0, length: boldString.characters.count)
    attributedString.addAttributes(boldAttribute, range: range)
    
    return attributedString
}
