//
//  BaseView.swift
//  FlickrImage
//
//  Created by Gagandeep Singh on 10/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit

public class BaseView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews() {
        
    }
    
}
