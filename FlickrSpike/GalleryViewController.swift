//
//  GalleryViewController.swift
//  FlickrSpike
//
//  Created by Gagandeep Singh on 18/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit
import MessageUI

class GalleryViewController: UIViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {

    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Data
    //----------------------------------------------------------------------------------------

    var flickrPhotos: [FlickrPhoto]? {
        didSet {
            flickrPhotoSplitView.reloadData()
            
            if let count = flickrPhotos?.count {
                
                if count == 0 {
                    detailsLabel.text = Strings.NoPhotosFound
                    return
                }
                
                if isSearching {
                    detailsLabel.text = Strings.ShowingPhotos(withCount: count, forTags: searchString)
                    
                } else {
                    detailsLabel.text = Strings.ShowingRecentPhotos(withCount: count)
                }
            }
        }
    }
    
    
    var sort: FlickrAPI.Sort = .DatePublished {
        didSet {
            resetflickrPhotos(in: flickrPhotoSplitView)
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
    
    var sortWindowStatus: SortWindowStatus = .closed
    enum SortWindowStatus {
        case open
        case closed
    }
    
    var sortWindowBottomAnchor: NSLayoutConstraint!
    
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
    lazy var tapToDismissKeyboard: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(dismissKeyboard))
        return tap
    }()
    
    
    lazy var tapToCloseSortWindow: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(closeSortWindow))
        return tap
    }()
    
    
    //MARK:- Spinner
    let spinner: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(activityIndicatorStyle: .white)
        av.translatesAutoresizingMaskIntoConstraints = false
        av.hidesWhenStopped = true
        return av
    }()
    
    lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: Images.FilterIcon, style: .plain, target: self, action: #selector(toggleSortWindow))
        return button
    }()
    
    let sortWindow: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .navBar()
        return view
    }()
    
    let sortStack: UIStackView = {
        let view = UIStackView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .navBar()
        view.alignment = .fill
        view.axis = .horizontal
        return view
    }()
    
    let sortWindowTitle: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .navBar()
        label.textAlignment = .center
        label.textColor = .lightGray()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = Strings.SortPhotos
        return label
    }()
    
    lazy var dateTakenButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Strings.DateTaken, for: [])
        button.setTitleColor(.white(), for: [])
        button.setTitleColor(.menuBarTint() , for: .disabled)
        button.backgroundColor = .navBar()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(switchSortBy(sender:)), for: .touchUpInside)
        return button
    }()
    
    
    lazy var datePublishedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Strings.DatePublished, for: [])
        button.setTitleColor(.white(), for: [])
        button.setTitleColor(.menuBarTint(), for: .disabled)
        button.backgroundColor = .navBar()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(switchSortBy(sender:)), for: .touchUpInside)
        return button
    }()
    
    let sortWindowPadding: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .navBar()
        return view
    }()
    
    
    
    let overlay: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black()
        view.alpha = 0
        return view
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
        
        switchSortBy(sender: datePublishedButton)
    }
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Setup View
    //----------------------------------------------------------------------------------------
    func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .navBar()
        navigationController?.navigationBar.tintColor = .white()
        navigationItem.leftBarButtonItem = filterButton
        
        navigationItem.titleView = searchBar
        navigationItem.title = Strings.Feed
    }
    
    func toggleSortWindow() {
        
        switch sortWindowStatus {
        case .open:
            closeSortWindow()
            
        default:
            openSortWindow()
        }
    }
    
    func openSortWindow() {
        
        sortWindowStatus = .open
        searchBar.isUserInteractionEnabled = false
        overlay.addGestureRecognizer(tapToCloseSortWindow)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.overlay.alpha = 0.5
            self.sortWindowBottomAnchor.constant = 60
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func closeSortWindow() {
        
        sortWindowStatus = .closed
        searchBar.isUserInteractionEnabled = true
        overlay.removeGestureRecognizer(tapToCloseSortWindow)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.overlay.alpha = 0
            self.sortWindowBottomAnchor.constant = 0
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func switchSortBy(sender: UIButton) {
        
        closeSortWindow()
        
        switch sender {
            
        case dateTakenButton:
            sort = .DateTaken
            datePublishedButton.isEnabled = true
            dateTakenButton.isEnabled = false
            
            
        default:
            sort = .DatePublished
            datePublishedButton.isEnabled = false
            dateTakenButton.isEnabled = true
        }
        
    }
    
    func setupViews() {
        
        //Details label
        view.addSubview(detailsLabel)
        detailsLabel.leftAnchor.constraint     (equalTo: view.leftAnchor)  .isActive = true
        detailsLabel.rightAnchor.constraint    (equalTo: view.rightAnchor) .isActive = true
        detailsLabel.topAnchor.constraint      (equalTo: view.topAnchor)   .isActive = true
        detailsLabel.heightAnchor.constraint   (equalToConstant: 20)       .isActive = true
        
        //spinner
        view.addSubview(spinner)
        spinner.widthAnchor.constraint      (equalToConstant: 20)               .isActive = true
        spinner.heightAnchor.constraint     (equalToConstant: 20)               .isActive = true
        spinner.centerXAnchor.constraint    (equalTo: detailsLabel.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint    (equalTo: detailsLabel.centerYAnchor).isActive = true
        
        //Split View
        view.addSubview(flickrPhotoSplitView)
        flickrPhotoSplitView.leftAnchor.constraint     (equalTo: view.leftAnchor)  .isActive = true
        flickrPhotoSplitView.rightAnchor.constraint    (equalTo: view.rightAnchor) .isActive = true
        flickrPhotoSplitView.topAnchor.constraint      (equalTo: detailsLabel.bottomAnchor)   .isActive = true
        flickrPhotoSplitView.bottomAnchor.constraint   (equalTo: view.bottomAnchor).isActive = true
        
        //Overlay
        view.addSubview(overlay)
        overlay.leftAnchor.constraint   (equalTo: view.leftAnchor)  .isActive = true
        overlay.rightAnchor.constraint  (equalTo: view.rightAnchor) .isActive = true
        overlay.topAnchor.constraint    (equalTo: view.topAnchor)   .isActive = true
        overlay.bottomAnchor.constraint (equalTo: view.bottomAnchor).isActive = true
        
        //Sort Window
        view.addSubview(sortWindow)
        sortWindow.leftAnchor.constraint    (equalTo: view.leftAnchor)  .isActive = true
        sortWindow.rightAnchor.constraint   (equalTo: view.rightAnchor) .isActive = true
        sortWindowBottomAnchor = sortWindow.bottomAnchor.constraint(equalTo: view.topAnchor)
        sortWindowBottomAnchor.isActive = true
        
        //Sort Window Title
        sortWindow.addSubview(sortWindowTitle)
        sortWindowTitle.leftAnchor.constraint   (equalTo: sortWindow.leftAnchor)  .isActive = true
        sortWindowTitle.rightAnchor.constraint  (equalTo: sortWindow.rightAnchor) .isActive = true
        sortWindowTitle.topAnchor.constraint    (equalTo: sortWindow.topAnchor).isActive = true
        sortWindowTitle.heightAnchor.constraint (equalToConstant: 20).isActive = true
        
        //Sort Stack
        sortWindow.addSubview(sortStack)
        sortStack.leftAnchor.constraint    (equalTo: sortWindow.leftAnchor)  .isActive = true
        sortStack.rightAnchor.constraint   (equalTo: sortWindow.rightAnchor) .isActive = true
        sortStack.topAnchor.constraint      (equalTo: sortWindowTitle.bottomAnchor).isActive = true
        sortStack.bottomAnchor.constraint   (equalTo: sortWindow.bottomAnchor) .isActive = true
        
        //Sort by Date Published Button
        sortStack.addArrangedSubview(datePublishedButton)
        datePublishedButton.widthAnchor.constraint(equalToConstant: MainScreen.Size.width / 2).isActive = true
        datePublishedButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //Sort by Date Taken Button
        sortStack.addArrangedSubview(dateTakenButton)
        dateTakenButton.widthAnchor.constraint(equalToConstant: MainScreen.Size.width / 2).isActive = true
        dateTakenButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    
    
    
}


//----------------------------------------------------------------------------------------
//MARK:
//MARK: Delegate methods for View Model
//----------------------------------------------------------------------------------------
extension GalleryViewController: GalleryViewModelDelegate {
    
    //----------------------------------------------------------------------------------------
    //MARK: Fetch Photos from Flickr
    //----------------------------------------------------------------------------------------
    func fetchRecentPhotosFromFlickr() {
        
        if Reachability.isConnectedToNetwork() {
            
            viewModel.fetchRecentImagesFromFlickr(atPage: pagesLoaded, sortedBy: sort)
            pagesLoaded += 1
            
        } else {
            showErrorMessage(forCode: Error.NoInternet.rawValue, completionHandler: nil)
        }
    }
    
    //----------------------------------------------------------------------------------------
    //MARK: Search Photos for Tags
    //----------------------------------------------------------------------------------------
    func handleSearch() {
        
        if Reachability.isConnectedToNetwork() {
            
            viewModel.searchflickrForTags(inString: searchString, onPage: pagesLoaded, sortedBy: sort)
            pagesLoaded += 1
            
        } else {
            showErrorMessage(forCode: Error.NoInternet.rawValue, completionHandler: nil)
        }
    }
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK: Delegate Methods
    //----------------------------------------------------------------------------------------
    //Show Loading Spinner
    func showProcessing() {
        detailsLabel.text = ""
        spinner.startAnimating()
    }
    
    //Hide Loading Spinner
    func hideProcessing() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
    
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
    
    
    //Successfully fetched photos for searched tags
    func searchCompleted(withPhotos photos: [FlickrPhoto], forSearchString searchString: String) {
        DispatchQueue.main.async {
            
            //If there are alredy photos loaded
            if let current = self.flickrPhotos {
                
                //If the search string hasnt changed, add new photos to current photos
                if self.searchString == searchString {
                    self.flickrPhotos =  current + photos
                    
                    //Else, set loaded photos
                } else {
                    self.flickrPhotos = photos
                }
                
                //Else, set loaded photos
            } else {
                self.flickrPhotos = photos
            }
        }
    }
}




//----------------------------------------------------------------------------------------
//MARK:
//MARK: Split View Delegate & Data Source Methods
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
        let userVc = UserPhotosViewController()
        userVc.user = user
        userVc.username = username
        navigationController?.pushViewController(userVc, animated: true)
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
        view.addGestureRecognizer(tapToDismissKeyboard)
    }
    
    //Remove Tap to dismiss keyboard from view
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapToDismissKeyboard)
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
    
    
    //MARK:- Dismiss Keyboard
    func dismissKeyboard() {
        searchBar.endEditing(true)
    }
}
