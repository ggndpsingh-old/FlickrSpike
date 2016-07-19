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

    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Data
    //----------------------------------------------------------------------------------------

    var flickrPhotos: [FlickrPhoto]? {
        didSet {
            flickrPhotoSplitView.reloadData()
            
            if let count = flickrPhotos?.count {
                
                if isSearching {
                    detailsLabel.text = Strings.ShowingAllPhotos(withCount: count, forTags: searchString)
                } else {
                    detailsLabel.text = Strings.ShowingAllRecentPhotos(withCount: count)
                }
            }
        }
    }
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Variables
    //----------------------------------------------------------------------------------------
    
    //MARK:- View Model for API Methods
    var viewModel: GalleryViewModel!
    
    //MARK:- Track number of plages loaded
    var pagesLoaded = 0
    
    
    //MARK:- Search Helpers
    var isSearching = false
    var searchString = ""
    
    //MARK:- Split View to show Table View & Collection View
    lazy var flickrPhotoSplitView: FlickrPhotoSplitView = {
        let sv = FlickrPhotoSplitView(frame: CGRect.zero)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.delegate = self
        sv.dataSource = self
        
        /*
            Split view can be reversed to switch the positions of Table View & Collection View
            Default is false, and Table View is shown first
        */
        sv.isReversed = false
        
        return sv
    }()
    
    //MARK:- Details Label
    let detailsLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = .navBar()
        label.textColor = .white()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    //MARK:- Search Bar
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar(frame: CGRect.zero)
        bar.delegate = self
        bar.searchBarStyle = UISearchBarStyle.minimal
        bar.placeholder = Strings.SearchTags
        bar.autocapitalizationType = .none
        bar.tintColor = UIColor.white()
        let textField = bar.value(forKey: "searchField") as! UITextField
        textField.textColor = UIColor.white()
        return bar
    }()
    
    //MARK:- Tap to dismiss keyboard
    lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(dismissKeyboard))
        return tap
    }()
    
    //MARK:- Spinner
    let spinner: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(activityIndicatorStyle: .white)
        av.translatesAutoresizingMaskIntoConstraints = false
        av.hidesWhenStopped = true
        return av
    }()
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: View Controller Lifecycle
    //----------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize View Model
        viewModel = GalleryViewModel(delegate: self)
        
        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = []
        
        setupNavigationBar()
        setupViews()
        
        fetchRecentPhotosFromFlickr()
    }
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Setup View
    //----------------------------------------------------------------------------------------
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
        
        view.addSubview(spinner)
        spinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        spinner.centerXAnchor.constraint(equalTo: detailsLabel.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: detailsLabel.centerYAnchor).isActive = true
        
        view.addSubview(flickrPhotoSplitView)
        flickrPhotoSplitView.leftAnchor.constraint     (equalTo: view.leftAnchor)  .isActive = true
        flickrPhotoSplitView.rightAnchor.constraint    (equalTo: view.rightAnchor) .isActive = true
        flickrPhotoSplitView.topAnchor.constraint      (equalTo: detailsLabel.bottomAnchor)   .isActive = true
        flickrPhotoSplitView.bottomAnchor.constraint   (equalTo: view.bottomAnchor).isActive = true
    }
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Fetch Photos from Flickr
    //----------------------------------------------------------------------------------------
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
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Delegate methods for View Model
    //----------------------------------------------------------------------------------------
    func showProcessing() {
        detailsLabel.text = ""
        spinner.startAnimating()
    }
    
    
    func hideProcessing() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
}




//----------------------------------------------------------------------------------------
//MARK:
//MARK: Flickr Photo Split View Delegate & Data Source Methods
//----------------------------------------------------------------------------------------

extension GalleryViewController: FlickrPhotoSplitViewDelegate, FlickrPhotoSplitViewDataSource {
    
    /*
        Called when Table View OR Collection View is about to show to last Photo
        Loads more photos from Flickr
    */
    func flickrPhotoSplitView(willDisplayLastItemFromflickrPhotos flickrPhotos: [FlickrPhoto]?) {
        isSearching ? handleSearch() : fetchRecentPhotosFromFlickr()
    }
    
    
    /*
        Sends the Photos to be displayed to Table View & Collection View
     */
    func flickrPhotosToDisplay(in flickrPhotoSplitView: FlickrPhotoSplitView) -> [FlickrPhoto]? {
        return flickrPhotos
    }
    
    
    /*
        Called from Refresh Controler in Table View & Collection View
     */
    func resetflickrPhotos(in flickrPhotoSplitView: FlickrPhotoSplitView) {
        flickrPhotos = nil
        pagesLoaded = 0
        isSearching ? handleSearch() : fetchRecentPhotosFromFlickr()
    }
    
    
    /*
        Displays the Options Action Sheet for a Photo
     */
    func showOptionsForFlickrPhoto(flickrPhoto: FlickrPhoto, withImageFile image: UIImage) {
        
        //Create Action Sheet Controller
        let actionSheet = UIAlertController(title: Strings.PhotoOptions, message: nil, preferredStyle: .actionSheet)
        
        
        //Save Photo To Gallery Action
        let saveAction = UIAlertAction(title: Strings.SavePhoto, style: .default) { _ in
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        
        //Open Photo in Safari Action
        let openInSafariAction = UIAlertAction(title: Strings.OpenInSafari, style: .default) { _ in
            if let url = flickrPhoto.flickrUrl {
                UIApplication.shared().open(URL(string: url)!, options: [:], completionHandler: nil)
            }
        }
        
        
        //Send Photo as Email Attatchement Action
        let sendEmailAction = UIAlertAction(title: Strings.ShareByEmail, style: .default) { _ in
            
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.addAttachmentData(UIImageJPEGRepresentation(image, 1)!, mimeType: "image/jpeg", fileName: "\(flickrPhoto.id!).jpeg")
            mailComposeVC.setSubject("\(flickrPhoto.title!)")
            
            self.present(mailComposeVC, animated: true, completion: nil)
        }
        
        
        //Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        //Add Actions
        actionSheet.addAction(saveAction)
        actionSheet.addAction(openInSafariAction)
        
        if MFMailComposeViewController.canSendMail() {
            actionSheet.addAction(sendEmailAction)
        }
        
        actionSheet.addAction(cancelAction)
        
        
        //Present Action Sheet
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    /*
        Result method for Saving Image to Device
     */
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            print("Success")
        } else {
            print("Failure")
        }
    }
    
    
    /*
        Result method for Mail Compose Controller
     */
    @objc(mailComposeController:didFinishWithResult:error:) func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: NSError?) {
        dismiss(animated: true, completion: nil)
        
    }
}




//----------------------------------------------------------------------------------------
//MARK:
//MARK: Search Handling
//----------------------------------------------------------------------------------------
extension GalleryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //If search bar is empty and the entereted text is a whitespace, do nothing
        if searchBar.text! == "" && text.trim().condenseWhitespace() == "" {
            return false
        
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let text = searchBar.text {
            
            //Only perform a search operation if the user stop typing for at least 0.5 seconds
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            
            //Remove whitespaces from Search String
            searchString = text.trim().condenseWhitespace()
            
            //At least three characters are required to perform a search
            if searchText.characters.count >= 3 {
                
                flickrPhotos = nil
                flickrPhotoSplitView.reloadData()
                
                isSearching = true
                self.perform(#selector(self.handleSearch), with: nil, afterDelay: 0.5)
                
            //If seach bar has been cleared, reset photos
            } else if searchText == "" {
                
                flickrPhotos = nil
                flickrPhotoSplitView.reloadData()
                
                isSearching = false
                fetchRecentPhotosFromFlickr()
            }
            
        }
    }
    
    
    //Add Tap to dismiss keyboard
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        view.addGestureRecognizer(tap)
    }
    
    //Remove Tap to dismiss keyboard from view
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tap)
    }
    
    //Handle search cancel
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
    
    
    //Hide keyboard on return key pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    
    //MARK:- Perform Search
    func handleSearch() {
        
        viewModel.searchflickrForTags(inString: searchString, onPage: pagesLoaded) { (searchedString, images, error) in
            DispatchQueue.main.async {
                
                //If there are alredy photos loaded
                if let current = self.flickrPhotos, loaded = images {
                    
                    //If the search string hasnt changed, add new photos to current photos
                    if self.searchString == searchedString {
                        self.flickrPhotos =  current + loaded
                    
                    //Else, set loaded photos
                    } else {
                        self.flickrPhotos = images
                    }
                
                //Else, set loaded photos
                } else {
                    self.flickrPhotos = images
                }
            }
        }
        pagesLoaded += 1
    }
    
    
    //MARK:- Dismiss Keyboard
    func dismissKeyboard() {
        searchBar.endEditing(true)
    }
}
