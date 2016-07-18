//
//  GalleryViewController.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 18/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit
import MessageUI

class GalleryViewController: UIViewController, GalleryViewModelDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {

    //MARK: Data
    var flickrPhotos: [FlickrPhoto]? {
        didSet {
            flickrPhotoSplitView.reloadData()
            
            if let count = flickrPhotos?.count {
                
                if isSearching {
                    detailsLabel.text = "Showing \(count) Photos for \(searchString)"
                } else {
                    detailsLabel.text = "Showing \(count) Recent Photos"
                }
            }
            
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = .navBar()
        label.textColor = .white()
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.text = "Showing Everything"
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
        
        view.addSubview(detailsLabel)
        detailsLabel.leftAnchor.constraint     (equalTo: view.leftAnchor)  .isActive = true
        detailsLabel.rightAnchor.constraint    (equalTo: view.rightAnchor) .isActive = true
        detailsLabel.topAnchor.constraint      (equalTo: view.topAnchor)   .isActive = true
        detailsLabel.heightAnchor.constraint   (equalToConstant: 20)       .isActive = true
        
        view.addSubview(flickrPhotoSplitView)
        flickrPhotoSplitView.leftAnchor.constraint     (equalTo: view.leftAnchor)  .isActive = true
        flickrPhotoSplitView.rightAnchor.constraint    (equalTo: view.rightAnchor) .isActive = true
        flickrPhotoSplitView.topAnchor.constraint      (equalTo: detailsLabel.bottomAnchor)   .isActive = true
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
    
    func showOptionsForFlickrPhoto(flickrPhoto: FlickrPhoto, withImageFile image: UIImage) {
        
        let actionSheet = UIAlertController(title: "Photo Options", message: nil, preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "Save Photo", style: .default) { _ in
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        let openInSafariAction = UIAlertAction(title: "Open in Safari", style: .default) { _ in
            if let url = flickrPhoto.flickrUrl {
                UIApplication.shared().open(URL(string: url)!, options: [:], completionHandler: nil)
            }
        }
        
        let sendEmailAction = UIAlertAction(title: "Share by Email", style: .default) { _ in
            
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.addAttachmentData(UIImageJPEGRepresentation(image, 1)!, mimeType: "image/jpeg", fileName: "\(flickrPhoto.id!).jpeg")
            mailComposeVC.setSubject("Flickr Photo: \(flickrPhoto.title)")
            
            self.present(mailComposeVC, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(saveAction)
        actionSheet.addAction(openInSafariAction)
        if MFMailComposeViewController.canSendMail() {
            actionSheet.addAction(sendEmailAction)
        }
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            print("Success")
        } else {
            print("Failure")
        }
    }
    
    @objc(mailComposeController:didFinishWithResult:error:) func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: NSError?) {
        dismiss(animated: true, completion: nil)
        
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
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        
        if searchBar.text != "" {
            searchBar.text = ""
            flickrPhotos = nil
            fetchRecentPhotosFromFlickr()
        }
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
