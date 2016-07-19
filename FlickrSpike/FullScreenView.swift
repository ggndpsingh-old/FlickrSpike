//
//  FullScreenView.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 18/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit

//A UIView for Note Details that can be used throughout the app
class FullScreenView: UIScrollView {
    
    
    //-----------------------------------------------------------------------------
    //MARK:
    //MARK: UI Elements
    //-----------------------------------------------------------------------------
    
    var photoWindow: UIWindow? = {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: MainScreen.Size.width, height: MainScreen.Size.height))
        window.backgroundColor = .black()
        return window
    }()
    
    var contentView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black()
        return view
    }()
    
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
    
    
    //-----------------------------------------------------------------------------
    //MARK:
    //MARK: Gesture Recognizers
    //-----------------------------------------------------------------------------
    
    /*
        Pan gesture is used to drag the Photo View downwards and closing the window.
     */
    lazy var pan: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(self.panImage(recognizer:)))
        return pan
    }()
    
    
    //-----------------------------------------------------------------------------
    //MARK:
    //MARK: Constraints
    //-----------------------------------------------------------------------------
    var photoLeftAnchor     : NSLayoutConstraint!
    var photoTopAnchor      : NSLayoutConstraint!
    var photoWidthAnchor    : NSLayoutConstraint!
    var photoHeightAnchor   : NSLayoutConstraint!
    
    
    //-----------------------------------------------------------------------------
    //MARK:
    //MARK: Constants
    //-----------------------------------------------------------------------------
    private struct Constants {
        static let MessageDuration: Double  = 0.2
        static let PanDistanceToDismiss: CGFloat = 160
    }
    
    
    //-----------------------------------------------------------------------------
    //MARK:
    //MARK: Variables
    //-----------------------------------------------------------------------------
    var totalMovement: CGFloat = 0
    var height: CGFloat = MainScreen.Size.width
    
    
    
    //-----------------------------------------------------------------------------
    //MARK:
    //MARK: Setup Views
    //-----------------------------------------------------------------------------
    func setupViews() {
        
        //Setup Scroll View
        frame = MainScreen.Size
        bounces = false
        backgroundColor = .black()
        showsVerticalScrollIndicator = false
        
        //Setup Content View
        contentSize = CGSize(width: MainScreen.Size.width, height: 1000)
        
        addSubview(contentView)
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: MainScreen.Size.width).isActive = true
        
        //Username Label
        contentView.addSubview(usernameLabel)
        usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        //Photo View
        contentView.addSubview(photoView)
        photoLeftAnchor =  photoView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0)
        photoTopAnchor = photoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0)
        photoWidthAnchor = photoView.widthAnchor.constraint(equalToConstant: MainScreen.Size.width)
        photoHeightAnchor = photoView.heightAnchor.constraint(equalToConstant: MainScreen.Size.width)
        
        photoLeftAnchor.isActive = true
        photoTopAnchor.isActive = true
        photoWidthAnchor.isActive = true
        photoHeightAnchor.isActive = true
        
        //Views Label
        contentView.addSubview(viewsLabel)
        viewsLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 16).isActive = true
        viewsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        viewsLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        viewsLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        //Tags Label
        contentView.addSubview(tagsLabel)
        tagsLabel.topAnchor.constraint(equalTo: viewsLabel.bottomAnchor, constant: 5).isActive = true
        tagsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        tagsLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        
        //Time Label
        contentView.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 20).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        
        
        //Setup Photo Window
        photoWindow!.addSubview(self)
        
        //Add Pan Gesture
        addGestureRecognizer(pan)
    }
    
    
    
    //-----------------------------------------------------------------------------
    //MARK:
    //MARK: Pan Gesture Delegate
    //-----------------------------------------------------------------------------
    
    /*
        Both Scroll & Pan cannot be used at the same time, so we modify our pan gesture to do the necessary scrolling.
     */
    func panImage(recognizer: UIPanGestureRecognizer) {
        
        //Distance Pan Gesture moved vertically
        let translation = recognizer.translation(in: self).y
        
        /*
            If the content view is longer than the screen, keep track of how much longer so that we can Scroll using Pan Gesture
            If the content view is smaller or equal to screen, set it to zero.
         */
        let difference = contentView.frame.size.height - MainScreen.Size.height > 0 ? contentView.frame.size.height - MainScreen.Size.height : 0
        
        
        
        //Switch between Gesture States
        switch recognizer.state {
        
        case .changed:
            
            /*
                This will take effect when the content view is longer than the screen and is above its bottom end
                This will scroll the view until it reaches bottom
             */
            if contentOffset.y >= 0 && contentOffset.y <= difference {
                contentOffset.y -= translation
            }
            
            /*
                This keeps the content scroll view within its bounds at top & bottom.
             */
            if contentOffset.y < 0 {
                contentOffset.y = 0
                
            } else if contentOffset.y > difference {
                contentOffset.y = difference - 0.5
            }
            
            
            /*
                This is where the magic happens.
                If the finger is moving downwards and the content offset is zero,
                We start dragging the Photo View downwards and decereasing the opacity of the entire window, to give a disappearing effect.
             */
            if translation > 0 && contentOffset.y == 0 {
                
                //Move the Photo View Downwards
                photoTopAnchor.constant += translation
                
                /*
                    Set opacity for the view.
                    Using 300 means that alpha value will hit Zero when the view moves 300 points.
                */
                self.alpha = 1 - totalMovement / 300
                
                //Keep track of total Pan Gesture Movemnt
                totalMovement += translation
            }
            
            
            /*
                Reset the translation to zero after each change, so that we dont get incremental translation.
             */
            recognizer.setTranslation(CGPoint.zero, in: self)
            
        
        case.ended:
            
            /*
                If the scroll view scrolls beyond its top or bottom end, bring it back when gesture ends.
            */
            if contentOffset.y < 0 {
                contentOffset.y = 0
            
            } else if contentOffset.y > difference {
                contentOffset.y = difference
            }
            
            /*
                If the Photo View has been drageed more than the Dimiss distance, close the window.
             */
            if totalMovement > Constants.PanDistanceToDismiss {
                photoWindow = nil
            
            /*
                 Else, bring the Photo View back to top and set alpha to 1.
             */
            } else {
                photoTopAnchor.constant = 64
                self.alpha = 1
                totalMovement = 0
            }
            
        default:
            break
        }
        
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
    
    
    //-----------------------------------------------------------------------------
    //MARK:
    //MARK: Show Full Screen View
    //-----------------------------------------------------------------------------
    func show(flickrPhoto photo: FlickrPhoto, withIntialRect rect: CGRect) {
        
        //Setup Views
        setupViews()
        
        /*
            Set Photo to Photo View & get the size of the photos
            The size of the photo is used to determine the ratio of width & height of the photo
            And that ratio is then set to the Photo View using constraints
        */
        photoView.loadImageUsingCache(withUrlString: photo.imageUrl!) { _ in
            if let image = self.photoView.image {
                self.height = MainScreen.Size.width / (image.size.width / image.size.height)
            }
        }
        
        //Fill Labels
        if let name = photo.ownerName {
            usernameLabel.text = name
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
        
        
        /*
            These constraints set the Photo View at the exact location in the window as the Photo Cell in the Collection View
        */
        photoLeftAnchor.constant    = rect.origin.x
        photoTopAnchor.constant     = rect.origin.y
        photoWidthAnchor.constant   = rect.width
        photoHeightAnchor.constant  = rect.height
        
        
        //Present the Window to the user
        photoWindow!.makeKeyAndVisible()
        
        //Show Message
        UIView.animate(withDuration: 0.001, delay: 0, options: .curveEaseOut, animations: {
            
            //This intial shot animation sets the above given constraints
            self.layoutIfNeeded()
            
        }) { _ in
            
            //Animate Photo View to the full screen position
            UIView.animate(withDuration: Constants.MessageDuration, delay: 0, options: .curveEaseOut, animations: {
                
                self.photoTopAnchor.constant = 64
                self.photoLeftAnchor.constant = 0
                self.photoWidthAnchor.constant = MainScreen.Size.width
                self.photoHeightAnchor.constant = self.height
                self.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
}
