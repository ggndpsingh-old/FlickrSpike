//
//  FlickrPhotoSplitView.swift
//  FlickrPhoto
//
//  Created by Gagandeep Singh on 11/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit


//--------------------------------------------------------------------------------
//MARK:
//MARK: Delegate for FlickrPhoto Split View
//--------------------------------------------------------------------------------
public protocol FlickrPhotoSplitViewDelegate: class {
    
    func flickrPhotoSplitView(willDisplayLastItemFromflickrPhotos flickrPhotos: [FlickrPhoto]?)
    func resetflickrPhotos(in flickrPhotoSplitView: FlickrPhotoSplitView)
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
    //MARK:- Delegate & Data Source
    //----------------------------------------------------------------------------------------
    var delegate    : FlickrPhotoSplitViewDelegate!
    var dataSource  : FlickrPhotoSplitViewDataSource!
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:- Variables
    //----------------------------------------------------------------------------------------
    var flickrPhotos: [FlickrPhoto]?
    
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
    //MARK:- Setup Views
    //----------------------------------------------------------------------------------------
    override func setupViews() {
        
        
        splitView.register(FlickrPhotoTableContainerCell.self, forCellWithReuseIdentifier: "flickrPhotoTableContainerCell")
        splitView.register(FlickrPhotoCollectionContainerCell.self, forCellWithReuseIdentifier: "flickrPhotoCollectionContainerCell")
        
        addSubview(menuBar)
        menuBar.topAnchor.constraint        (equalTo: topAnchor)    .isActive = true
        menuBar.leftAnchor.constraint       (equalTo: leftAnchor)   .isActive = true
        menuBar.rightAnchor.constraint      (equalTo: rightAnchor)  .isActive = true
        menuBar.heightAnchor.constraint     (equalToConstant: 50)   .isActive = true
        
        addSubview(splitView)
        splitView.leftAnchor.constraint     (equalTo: leftAnchor)   .isActive = true
        splitView.rightAnchor.constraint    (equalTo: rightAnchor)  .isActive = true
        splitView.bottomAnchor.constraint   (equalTo: bottomAnchor) .isActive = true
        splitView.topAnchor.constraint      (equalTo: menuBar.bottomAnchor)    .isActive = true
    }
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:- Reload Data
    //----------------------------------------------------------------------------------------
    func reset() {
        self.flickrPhotos = nil
        splitView.reloadData()
        delegate.resetflickrPhotos(in: self)
    }
    
    func reloadData() {
        if let flickrPhotos = dataSource.flickrPhotosToDisplay(in: self) {
            self.flickrPhotos = flickrPhotos
            splitView.reloadData()
        }
    }
    
    func tableViewWillDisplayLastItem() {
        delegate.flickrPhotoSplitView(willDisplayLastItemFromflickrPhotos: flickrPhotos)
    }
    
    func collectionViewWillDisplayLastItem() {
        delegate.flickrPhotoSplitView(willDisplayLastItemFromflickrPhotos: flickrPhotos)
    }
    
    func collectionViewDidSelectItem(at index: Int) {
        tableView?.scrollToItemSelectedInCollectionView(at: index)
        splitView.scrollToItem(at: IndexPath(item: 0, section: 0), at: [], animated: true)
    }
    
    
    //----------------------------------------------------------------------------------------
    //MARK:- Menu Bar Helpers
    //----------------------------------------------------------------------------------------
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        menuBar.horizontalBarLeftAnchorConstraint.constant = x / 2
        let index = x / (MainScreen.Size.width / 2)
        menuBar.selectItem(at: Int(index))
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
    }
}




//--------------------------------------------------------------------------------
//MARK:
//MARK: Split Collection View Delegate & Data Source
//--------------------------------------------------------------------------------
extension FlickrPhotoSplitView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tableContainerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "flickrPhotoTableContainerCell", for: indexPath) as! FlickrPhotoTableContainerCell
        tableView = tableContainerCell.tableView
        
        let collectionContainerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "flickrPhotoCollectionContainerCell", for: indexPath) as! FlickrPhotoCollectionContainerCell
        self.collectionView = collectionContainerCell.collectionView
        
        let cells: [UICollectionViewCell] = [tableContainerCell, collectionContainerCell]
        
        if indexPath.item == 0 {
            
            return cells[indexPath.row]
            
        } else {
            
            return cells[indexPath.row]
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height - 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let item = indexPath.item {
            if item == 0  {
                tableView?.reloadData()
            } else {
                self.collectionView?.reloadData()
            }
        }
    }
}
