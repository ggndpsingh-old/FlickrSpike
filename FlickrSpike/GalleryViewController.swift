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
    
    var isSearching = false
    var searchString = ""
    
    
    lazy var flickrPhotoSplitView: FlickrPhotoSplitView = {
        let sv = FlickrPhotoSplitView(frame: CGRect.zero)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.delegate = self
        sv.dataSource = self
        return sv
    }()
    
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar(frame: CGRect.zero)
        bar.delegate = self
        bar.searchBarStyle = UISearchBarStyle.minimal
        bar.placeholder = "Search Tags"
        bar.autocapitalizationType = .none
        bar.tintColor = UIColor.white()
        let textField = bar.value(forKey: "searchField") as! UITextField
        textField.textColor = UIColor.white()
        return bar
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        viewModel = GalleryViewModel(delegate: self)
        fetchRecentPhotosFromFlickr()
        edgesForExtendedLayout = []
        
        setupNavigationBar()
        setupViews()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .navBar()
        navigationController?.hidesBarsOnSwipe = true
        navigationItem.titleView = searchBar
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
        isSearching ? handleSearch() : fetchRecentPhotosFromFlickr()
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

extension GalleryViewController: UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text {
            
            flickrPhotos = nil
            flickrPhotoSplitView.reloadData()
            
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            searchString = text
            
            if text == "" {
                isSearching = false
                fetchRecentPhotosFromFlickr()
                
            } else {
                isSearching = true
                self.perform(#selector(self.handleSearch), with: nil, afterDelay: 0.5)
            }
            
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        flickrPhotos = nil
        fetchRecentPhotosFromFlickr()
    }
    
    func handleSearch() {
        
        pagesLoaded += 1
        viewModel.searchflickrForTags(inString: searchString, onPage: pagesLoaded) { (searchedString, images, error) in
            DispatchQueue.main.async {
                if let current = self.flickrPhotos, loaded = images {
                    
                    if self.searchString == searchedString {
                        self.flickrPhotos =  current + loaded
                    } else {
                        self.flickrPhotos = images
                    }
                    
                } else {
                    self.flickrPhotos = images
                }
            }
        }
    }
}
