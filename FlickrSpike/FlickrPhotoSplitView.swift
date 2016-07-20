//
//  FlickrPhotoSplitView.swift
//  FlickrPhoto
//
//  Created by Gagandeep Singh on 11/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit


/*
 
    A Split View built using multiple UICollectionViews.
    
    Main Component is a nearly full screen UICollectionView, which has two cells.
        - One of the cells contains a UITableView & the other contains a UICollectionView.
        - Both child views display the same data and are kept in sync at all times.
    
    Top Component is a Menu Bar, which is a small UICollectionView and acts like a custom TabBarController to switch between Main Component's cells.
 
    Split View has 5 Delegate and Data Source methods which are added to any View Controller that conforms to the required Delegate & Data Source methods.
 
 */



//--------------------------------------------------------------------------------
//MARK:
//MARK: Delegate for FlickrPhoto Split View
//--------------------------------------------------------------------------------
public protocol FlickrPhotoSplitViewDelegate: class {
    
    func flickrPhotoSplitView(willDisplayLastItemFromflickrPhotos flickrPhotos: [FlickrPhoto]?)
    func resetflickrPhotos(in flickrPhotoSplitView: FlickrPhotoSplitView)
    func showOptionsForFlickrPhoto(flickrPhoto: FlickrPhoto, withImageFile image: UIImage, atIndexPath indexPath: IndexPath)
    
    func showUserPhotos(forUser user: String, withUsername username: String)
}


//--------------------------------------------------------------------------------
//MARK:
//MARK: Data Source for FlickrPhoto Split View
//--------------------------------------------------------------------------------
public protocol FlickrPhotoSplitViewDataSource: class {
    func flickrPhotosToDisplay(in flickrPhotoSplitView: FlickrPhotoSplitView) -> [FlickrPhoto]?
}




//--------------------------------------------------------------------------------
//MARK:
//MARK: FlickrPhoto Split View Class
//--------------------------------------------------------------------------------
public class FlickrPhotoSplitView: BaseView {
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK:- Delegate & Data Source
    //----------------------------------------------------------------------------------------
    var delegate    : FlickrPhotoSplitViewDelegate!
    var dataSource  : FlickrPhotoSplitViewDataSource!
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK:- Data
    //----------------------------------------------------------------------------------------
    var flickrPhotos: [FlickrPhoto]?
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK:- UI Elements
    //----------------------------------------------------------------------------------------
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.translatesAutoresizingMaskIntoConstraints = false
        mb.splitView = self
        return mb
    }()
    
    lazy var splitView: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.bounces = false
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    
    var tableView: FlickrPhotoTableView? {
        didSet {
            tableView?.splitView = self
            tableView?.flickrPhotos = flickrPhotos
        }
    }
    
    var collectionView: FlickrPhotoCollectionView? {
        didSet {
            self.collectionView?.splitView = self
            self.collectionView?.flickrPhotos = flickrPhotos
        }
    }
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK:- Constants
    //----------------------------------------------------------------------------------------
    struct Constants {
        
        struct CellIds {
            static let TableContainer       = "flickrPhotoTableContainerCell"
            static let CollectionContainer  = "flickrPhotoCollectionContainerCell"
        }
    }
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK:- Constants
    //----------------------------------------------------------------------------------------
    var isReversed = false
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK:- Setup Views
    //----------------------------------------------------------------------------------------
    override func setupViews() {
        
        //Register Container Cells
        
        /*
            These cells contain the Table View & Collection View to display the Photos
         */
        splitView.register(FlickrPhotoTableContainerCell.self,      forCellWithReuseIdentifier: Constants.CellIds.TableContainer)
        splitView.register(FlickrPhotoCollectionContainerCell.self, forCellWithReuseIdentifier: Constants.CellIds.CollectionContainer)
        
        
        //Menu Bar
        /*
            This is a custom TabBar, used to switch between Table & Collectin View
         */
        addSubview(menuBar)
        menuBar.topAnchor.constraint        (equalTo: topAnchor)            .isActive = true
        menuBar.leftAnchor.constraint       (equalTo: leftAnchor)           .isActive = true
        menuBar.rightAnchor.constraint      (equalTo: rightAnchor)          .isActive = true
        menuBar.heightAnchor.constraint     (equalToConstant: 50)           .isActive = true
        
        
        //The main Split UICollectionView
        addSubview(splitView)
        splitView.leftAnchor.constraint     (equalTo: leftAnchor)           .isActive = true
        splitView.rightAnchor.constraint    (equalTo: rightAnchor)          .isActive = true
        splitView.bottomAnchor.constraint   (equalTo: bottomAnchor)         .isActive = true
        splitView.topAnchor.constraint      (equalTo: menuBar.bottomAnchor) .isActive = true
    }
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK:- Table & Collection View Helper Methods
    //----------------------------------------------------------------------------------------
    
    /*
        Called from the UIRefreshControl of both Table & Collectionn View and is passed on to the delegate View Controller
     */
    func reset() {
        self.flickrPhotos = nil
        splitView.reloadData()
        delegate.resetflickrPhotos(in: self)
    }
    
    /*
        Called by the Table View when it is about to display its last item.
        Is passed on the delegate View Controller to load more Photos.
     */
    func tableViewWillDisplayLastItem() {
        delegate.flickrPhotoSplitView(willDisplayLastItemFromflickrPhotos: flickrPhotos)
    }
    
    /*
        Called by the Collection View when it is about to display its last item.
        Is passed on the delegate View Controller to load more Photos.
     */
    func collectionViewWillDisplayLastItem() {
        delegate.flickrPhotoSplitView(willDisplayLastItemFromflickrPhotos: flickrPhotos)
    }
    
    /*
        Called by the Table View when the Options buttons is pressed or the Photo receives a Long Press Gesture
        Is passed on the delegate View Controller to show Image options ActionSheet.
     */
    func showOptionsForFlickrPhoto(flickrPhoto: FlickrPhoto, withImageFile image: UIImage, atIndexPath indexPath: IndexPath) {
        delegate.showOptionsForFlickrPhoto(flickrPhoto: flickrPhoto, withImageFile: image, atIndexPath: indexPath)
    }
    
    /*
        Called by the Table View when the Username button is tapped.
        Is passed on the delegate View Controller with the Photo's Owner information to show the owner's photos.
     */
    func showUserPhotos(forUser user: String, withUsername username: String) {
        delegate.showUserPhotos(forUser: user, withUsername: username)
    }
    
    /*
        Can be called from the delegate View Controller and forces the Table & COllectin View to reload their data.
     */
    func reloadData() {
        if let flickrPhotos = dataSource.flickrPhotosToDisplay(in: self) {
            self.flickrPhotos = flickrPhotos
            splitView.reloadData()
        }
    }
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK:- Menu Bar Helpers
    //----------------------------------------------------------------------------------------
    
    /*
        All these methods make sure the Menu Bar and Split View are alwasy in sync as to which cell is active at any point.
     */
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        menuBar.horizontalBarLeftAnchorConstraint.constant = x / 2
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / frame.width
        menuBar.selectItem(at: Int(index))
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / frame.width
        menuBar.selectItem(at: Int(index))
    }
    
    func scrollToIndex(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        splitView?.scrollToItem(at: indexPath, at: [], animated: true)
        menuBar.selectItem(at: Int(index))
    }
}




//--------------------------------------------------------------------------------
//MARK:
//MARK: Split Collection View Delegate & Data Source
//--------------------------------------------------------------------------------
extension FlickrPhotoSplitView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /*
        UICollectinView Delegate & Data Source methods for the Main Split View
     */
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    /*
        Initialize the two container cells here.
        Use an array to determinate the cell position in case the Split View has been reversed.
     */
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tableContainerCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIds.TableContainer, for: indexPath) as! FlickrPhotoTableContainerCell
        tableView = tableContainerCell.tableView
        
        let collectionContainerCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIds.CollectionContainer, for: indexPath) as! FlickrPhotoCollectionContainerCell
        self.collectionView = collectionContainerCell.collectionView
        
        let cells: [UICollectionViewCell] = [tableContainerCell, collectionContainerCell]
        
        if indexPath.item == 0 {
            
            return isReversed ? cells.reversed()[indexPath.row] : cells[indexPath.row]
            
        } else {
            
            return isReversed ? cells.reversed()[indexPath.row] : cells[indexPath.row]
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    /*
        The Collection View is full screen   minus   height of the Menu Bar
     */
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height - 50)
    }
}
