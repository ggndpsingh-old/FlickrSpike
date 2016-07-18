//
//  GalleryViewController.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 18/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, GalleryViewModelDelegate {

    //MARK: Variables
    var viewModel: GalleryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = GalleryViewModel(delegate: self)
        
        fetchRecentPhotosFromFlickr()
    }
    
    func fetchRecentPhotosFromFlickr() {
        viewModel.fetchRecentImagesFromFlickr { (images, error) in
            print(images?.count)
        }
    }
}
