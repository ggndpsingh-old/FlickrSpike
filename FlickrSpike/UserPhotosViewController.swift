//
//  UserPhotosViewController.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 19/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit
import MessageUI

class UserPhotosViewController: UIViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Data
    //----------------------------------------------------------------------------------------
    
    var user: String?
    
    var username: String? {
        didSet {
            title = username!
        }
    }
    
    var flickrPhotos: [FlickrPhoto]? {
        didSet {
            flickrPhotoSplitView.reloadData()
        }
    }
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Variables
    //----------------------------------------------------------------------------------------
    
    //MARK:- View Model for API Methods
    var viewModel: UserPhotosViewModel!
    
    //MARK:- Track number of plages loaded
    var pagesLoaded = 0
    
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
        sv.isReversed = true
        
        return sv
    }()
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: View Controller Lifecycle
    //----------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize View Model
        viewModel = UserPhotosViewModel(delegate: self)
        
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
        navigationController?.navigationBar.tintColor = .white()
        navigationItem.titleView?.tintColor = .white()
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func setupViews() {
        
        //Split View
        view.addSubview(flickrPhotoSplitView)
        flickrPhotoSplitView.leftAnchor.constraint     (equalTo: view.leftAnchor)  .isActive = true
        flickrPhotoSplitView.rightAnchor.constraint    (equalTo: view.rightAnchor) .isActive = true
        flickrPhotoSplitView.topAnchor.constraint      (equalTo: view.topAnchor)   .isActive = true
        flickrPhotoSplitView.bottomAnchor.constraint   (equalTo: view.bottomAnchor).isActive = true
    }
    
    
    
    
}


//----------------------------------------------------------------------------------------
//MARK:
//MARK: Delegate methods for View Model
//----------------------------------------------------------------------------------------
extension UserPhotosViewController: UserPhotosViewModelDelegate {
    
    //----------------------------------------------------------------------------------------
    //MARK: Fetch Photos from Flickr
    //----------------------------------------------------------------------------------------
    func fetchRecentPhotosFromFlickr() {
        
        if Reachability.isConnectedToNetwork() {
            print(user!, pagesLoaded, FlickrAPI.Sort.DateTaken)
            viewModel.fetchRecentImagesFromFlickr(forUser: user!, atPage: pagesLoaded, sortedBy: FlickrAPI.Sort.DateTaken)
            pagesLoaded += 1
            
        } else {
            showErrorMessage(forCode: Error.NoInternet.rawValue, completionHandler: nil)
        }
    }
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK: Delegate Methods
    //----------------------------------------------------------------------------------------
    //Show Loading Spinner
    //If fetch or search failes, show an error message
    func fetchFailed(withError error: Int?) {
        DispatchQueue.main.async {
            showErrorMessage(forCode: error!, completionHandler: nil)
        }
    }
    
    
    //Successfully fetched Recent Photos from Flickr
    func fetchCompleted(withPhotos photos: [FlickrPhoto]) {
        DispatchQueue.main.async {
            
            //If there are alredy photos loaded, add new photos to current photos
            if let current = self.flickrPhotos {
                self.flickrPhotos = current + photos
                
            } else { //Set loaded photo
                self.flickrPhotos = photos
            }
        }
    }
}




//----------------------------------------------------------------------------------------
//MARK:
//MARK: Flickr Photo Split View Delegate & Data Source Methods
//----------------------------------------------------------------------------------------

extension UserPhotosViewController: FlickrPhotoSplitViewDelegate, FlickrPhotoSplitViewDataSource {
    
    /*
     Called when Table View OR Collection View is about to show to last Photo
     Loads more photos from Flickr
     */
    func flickrPhotoSplitView(willDisplayLastItemFromflickrPhotos flickrPhotos: [FlickrPhoto]?) {
        fetchRecentPhotosFromFlickr()
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
        fetchRecentPhotosFromFlickr()
    }
    
    
    /*
     Displays the Options Action Sheet for a Photo
     */
    func showOptionsForFlickrPhoto(flickrPhoto: FlickrPhoto, withImageFile image: UIImage, atIndexPath indexPath: IndexPath) {
        
        //Create Action Sheet Controller
        let actionSheet = UIAlertController(title: Strings.PhotoOptions, message: nil, preferredStyle: .actionSheet)
        
        //Setup Popup Presentation Controller Source for iPad
        actionSheet.popoverPresentationController?.permittedArrowDirections = .up
        
        //Get Table View from Split View
        let tableView = flickrPhotoSplitView.tableView!
        
        //Get Rect for Header of selected photo
        let rectForHeader = tableView.rectForHeader(inSection: indexPath.section)
        
        //Get Rect for Header in current view
        let rectInView = tableView.convert(rectForHeader, to: self.view)
        
        //Calculate Rect for the options button
        let buttonRect = CGRect(x: MainScreen.Size.width - 60, y: rectInView.origin.y, width: 50, height: 50)
        
        //Set sources for the popup presentation controller
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.sourceRect = buttonRect
        
        
        
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
        let cancelAction = UIAlertAction(title: Strings.Cancel, style: .cancel, handler: nil)
        
        
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
            Views.MessageView.show(withMessage: Strings.PhotoSavedSuccessfuly, valid: true, completion: nil)
            
        } else {
            Views.MessageView.show(withMessage: Strings.PhotoSaveFailed, valid: false, completion: nil)
        }
    }
    
    
    /*
     Result method for Mail Compose Controller
     */
    @objc(mailComposeController:didFinishWithResult:error:) func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: NSError?) {
        
        dismiss(animated: true, completion: nil)
        
        switch result {
            
        case .sent:
            Views.MessageView.show(withMessage: Strings.EmailSent, valid: true, completion: nil)
        case .cancelled:
            Views.MessageView.show(withMessage: Strings.EmailCancelled, valid: false, completion: nil)
            
        case .failed:
            Views.MessageView.show(withMessage: Strings.EmailFailed, valid: false, completion: nil)
            
        default:
            break
        }
        
    }
    
    func showUserPhotos(forUser user: String, withUsername username: String) {
    }
}
