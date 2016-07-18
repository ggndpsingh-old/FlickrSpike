//
//  ErrorMessageView.swift
//  LandmarkRemark
//
//  Created by Gagandeep Singh on 27/6/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit

//A UIView for Note Details that can be used throughout the app
class ErrorMessageView: BaseView {
    
    
    //-----------------------------------------------------------------------------
    //MARK:
    //MARK: Views
    //-----------------------------------------------------------------------------
    var photoView: UIImageView = {
        let iv = UIImageView(frame: CGRect.zero)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .left
        label.textColor = .white()
        return label
    }()
    
    var tagsLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var viewsLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.lightGray()
        return label
    }()
    
    lazy var pan: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(self.panImage(recognizer:)))
        return pan
    }()
    
    var totalMovement: CGFloat = 0
    func panImage(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self)
        
        
        switch recognizer.state {
        
        case .changed:
            photoTopAnchor.constant += translation.y
            totalMovement += translation.y
            recognizer.setTranslation(CGPoint.zero, in: self)
            
            let alpha = 1 - totalMovement / 300
            self.alpha = alpha
            
        case.ended:
            if totalMovement > 160 {
                photoWindow = nil
            } else {
                photoTopAnchor.constant = 64
                self.alpha = 1
                totalMovement = 0
            }
            
        default:
            break
        }
        
    }
    
    
    //-----------------------------------------------------------------------------
    //MARK:
    //MARK: Constants
    //-----------------------------------------------------------------------------
    private struct Constants {
        static let MessageDuration: Double  = 0.2
    }
    
    
    var photoLeftAnchor: NSLayoutConstraint!
    var photoTopAnchor: NSLayoutConstraint!
    var photoWidthAnchor: NSLayoutConstraint!
    var photoHeightAnchor: NSLayoutConstraint!
    var height: CGFloat = MainScreen.Size.width
    
    
    func addViews() {
        addSubview(usernameLabel)
        usernameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        addSubview(viewsLabel)
        viewsLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        viewsLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        viewsLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        addSubview(tagsLabel)
        tagsLabel.topAnchor.constraint(equalTo: viewsLabel.bottomAnchor, constant: 5).isActive = true
        tagsLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        tagsLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
        addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 20).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addGestureRecognizer(pan)
        
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
    
    var photoWindow: UIWindow?
    //-----------------------------------------------------------------------------
    //MARK:
    //MARK: Show Error
    //-----------------------------------------------------------------------------
    func show(flickrPhoto photo: FlickrPhoto, withIntialRect rect: CGRect) {
        
        photoView.loadImageUsingCache(withUrlString: photo.imageUrl!) { _ in
            if let image = self.photoView.image {
                self.height = MainScreen.Size.width / (image.size.width / image.size.height)
            }
        }
        
        if let name = photo.ownerName {
            usernameLabel.text = name
            addViews()
        }
        
        if let views = photo.views {
            viewsLabel.attributedText = createAttributdString(withAddedBoldString: "Views:", toString: views, withFontSize: 13)
        }
        
        if let tags = photo.tags {
            let separated = tags.components(separatedBy: .whitespaces).joined(separator: ", ")
            tagsLabel.attributedText = createAttributdString(withAddedBoldString: "Tags:", toString: separated, withFontSize: 13)
        }
        
        if let date = photo.published {
            timeLabel.text = date.longFormat()
        }
        
        //Use UIWindow to present it above the Status Bar
        photoWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: MainScreen.Size.width, height: MainScreen.Size.height))
        photoWindow!.backgroundColor = .clear()
        
        photoWindow!.makeKeyAndVisible()
        
        frame = MainScreen.Size
        backgroundColor = .black()
//        view.alpha = 0
        
        photoWindow!.addSubview(self)
        addSubview(photoView)
        
        photoLeftAnchor =  photoView.leftAnchor.constraint(equalTo: leftAnchor, constant: rect.origin.x)
        photoTopAnchor = photoView.topAnchor.constraint(equalTo: topAnchor, constant: rect.origin.y + 134)
        photoWidthAnchor = photoView.widthAnchor.constraint(equalToConstant: rect.width)
        photoHeightAnchor = photoView.heightAnchor.constraint(equalToConstant: rect.height)
        
        viewsLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 16).isActive = true

        photoLeftAnchor.isActive = true
        photoTopAnchor.isActive = true
        photoWidthAnchor.isActive = true
        photoHeightAnchor.isActive = true
        
        //Show Message
        
        UIView.animate(withDuration: 0.001, delay: 0, options: .curveEaseOut, animations: {
            
            self.layoutIfNeeded()
            
        }) { (completed) in
                UIView.animate(withDuration: Constants.MessageDuration, delay: 0, options: .curveEaseOut, animations: {
//                    view.alpha = 1
                    self.photoTopAnchor.constant = 64
                    self.photoLeftAnchor.constant = 0
                    
                    self.photoWidthAnchor.constant = MainScreen.Size.width
                    self.photoHeightAnchor.constant = self.height
                    self.layoutIfNeeded()
                    }, completion: { (completed) in
                        
                })
        }
        
    }
}
