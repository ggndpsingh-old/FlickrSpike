//
//  ErrorMessageView.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 19/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit


class ErrorMessageView: BaseView {
    
    
    //-----------------------------------------------------------------------------
    //MARK:
    //MARK: Views
    //-----------------------------------------------------------------------------
    
    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        view.effect = blurEffect
        return view
    }()
    
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    
    //-----------------------------------------------------------------------------
    //MARK:
    //MARK: Constants
    //-----------------------------------------------------------------------------
    private struct Constants {
        static let MessageDuration: Double  = 0.2
        static let MessageDelay: Double     = 2.5
    }
    
    
    
    //-----------------------------------------------------------------------------
    //MARK:
    //MARK: Variables
    //-----------------------------------------------------------------------------
    var message: String! {
        didSet {
            messageLabel.text = message
        }
    }
    
    //-----------------------------------------------------------------------------
    //MARK:
    //MARK: Set up views
    //-----------------------------------------------------------------------------
    override func setupViews() {
        super.setupViews()
        
        frame = CGRect(origin: CGPoint.zero, size: CGSize(width: MainScreen.Size.width, height: 80))
        
        addSubview(blurView)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: blurView)
        addConstraintsWithFormat(format: "V:|-20-[v0(60)]|", views: blurView)
        
        blurView.addSubview(messageLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: messageLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: messageLabel)
        
    }
    
    
    
    //-----------------------------------------------------------------------------
    //MARK:
    //MARK: Show Error
    //-----------------------------------------------------------------------------
    func show(withMessage message: String, valid: Bool, completion: ((completed: Bool) -> Void)? ) {
        
        self.message = message
        //Use UIWindow to present it above the Status Bar
        var window: UIWindow? = UIWindow(frame: CGRect(x: 0, y: 0, width: MainScreen.Size.width, height: 80))
        window!.windowLevel = UIWindowLevelStatusBar + 1
        
        let view = self
        view.frame = window!.bounds
        view.frame.origin.y = -80
        
        view.blurView.layer.cornerRadius = 16
        view.blurView.clipsToBounds = true
        
        window!.addSubview(view)
        window!.makeKeyAndVisible()
        
        //Show Message
        UIView.animate(withDuration: Constants.MessageDuration, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            view.frame.origin.y = 0
            }, completion: nil)
        
        //Hide Message after desired time
        UIView.animate(withDuration: Constants.MessageDuration, delay: Constants.MessageDelay, options: UIViewAnimationOptions.curveEaseOut, animations: {
            view.frame.origin.y = -80
        }) { (success) -> Void in
            
            window = nil
            completion?(completed: true)
        }
    }    
}
