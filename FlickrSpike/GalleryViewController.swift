//
//  GalleryViewController.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 18/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, GalleryViewModelDelegate {

    //MARK: Data
    var flickrPhotos: [FlickrPhoto]? {
        didSet {
            flickrPhotoSplitView.reloadData()
        }
    }
    
    //MARK: Variables
    var viewModel: GalleryViewModel!
    var pagesLoaded = 0
    
    lazy var flickrPhotoSplitView: FlickrPhotoSplitView = {
        let sv = FlickrPhotoSplitView(frame: CGRect.zero)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.delegate = self
        sv.dataSource = self
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = GalleryViewModel(delegate: self)
        fetchRecentPhotosFromFlickr()
        edgesForExtendedLayout = []
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .navBar()
        
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(flickrPhotoSplitView)
        flickrPhotoSplitView.leftAnchor.constraint     (equalTo: view.leftAnchor)  .isActive = true
        flickrPhotoSplitView.rightAnchor.constraint    (equalTo: view.rightAnchor) .isActive = true
        flickrPhotoSplitView.topAnchor.constraint      (equalTo: view.topAnchor)   .isActive = true
        flickrPhotoSplitView.bottomAnchor.constraint   (equalTo: view.bottomAnchor).isActive = true
    }
    
    func fetchRecentPhotosFromFlickr() {
        viewModel.fetchRecentImagesFromFlickr(atPage: pagesLoaded) { (loadedPhotos, error) in
            DispatchQueue.main.async {
                
                //If there are alredy photos loaded, add new photos to current photos
                if let current = self.flickrPhotos, loaded = loadedPhotos {
                    self.flickrPhotos = current + loaded
                    
                } else { //Set loaded photo
                    self.flickrPhotos = loadedPhotos
                }
            }
        }
        pagesLoaded += 1
    }
}

//----------------------------------------------------------------------------------------
//MARK:
//MARK: Flickr Photo Split View Data Source Methods
//----------------------------------------------------------------------------------------
extension GalleryViewController: FlickrPhotoSplitViewDelegate, FlickrPhotoSplitViewDataSource {
    
    func flickrPhotoSplitView(willDisplayLastItemFromflickrPhotos flickrPhotos: [FlickrPhoto]?) {
        fetchRecentPhotosFromFlickr()
    }
    
    func flickrPhotosToDisplay(in flickrPhotoSplitView: FlickrPhotoSplitView) -> [FlickrPhoto]? {
        return flickrPhotos
    }
    
    func resetflickrPhotos(in flickrPhotoSplitView: FlickrPhotoSplitView) {
        flickrPhotos = nil
        pagesLoaded = 0
        fetchRecentPhotosFromFlickr()
    }
}
