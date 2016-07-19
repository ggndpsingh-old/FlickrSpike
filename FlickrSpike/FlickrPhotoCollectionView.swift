//
//  FlickrPhotoCollectionView.swift
//  FlickrPhoto
//
//  Created by Gagandeep Singh on 11/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit

public protocol FlickrPhotoCollectionDataSource: class {
    
    func flickrPhotoCollectionView(_ flickrPhotoTableView: FlickrPhotoCollectionView, fetchMoreflickrPhotos skip: Int)
    func reloadflickrPhotos(in flickrPhotoCollectionView: FlickrPhotoCollectionView)
}




public class FlickrPhotoCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: UI Elements
    //----------------------------------------------------------------------------------------
    lazy public var refresher: UIRefreshControl! = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(reload), for: .valueChanged)
        return rc
    }()
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Constants
    //----------------------------------------------------------------------------------------
    struct Constants {
        
        struct CellIds {
            static let PhotoCell = "flickrPhotoCollectionViewCell"
        }
    }
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Variables
    //----------------------------------------------------------------------------------------
    var flickrPhotos: [FlickrPhoto]? {
        didSet {
            reloadData()
        }
    }
    
    var splitView: FlickrPhotoSplitView!
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Initializers
    //----------------------------------------------------------------------------------------
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        backgroundColor = UIColor.white()
        
        //Set delegate & data source
        delegate = self
        dataSource = self
        
        //register FlickrPhoto Cell
        register(FlickrPhotoCollectionViewCell.self, forCellWithReuseIdentifier: Constants.CellIds.PhotoCell)
        
        addSubview(refresher)
        reloadData()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Collection View Delegae & Data Source
    //----------------------------------------------------------------------------------------
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrPhotos?.count ?? 0
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIds.PhotoCell, for: indexPath) as! FlickrPhotoCollectionViewCell
        cell.indexPath = indexPath
        cell.flickrPhoto = flickrPhotos?[indexPath.item!]
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let distance = 2 / MainScreen.Scale
        return CGSize(width: MainScreen.Size.width / 3 - distance, height: MainScreen.Size.width / 3 - distance)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1 / MainScreen.Scale
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1 / MainScreen.Scale
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let item = indexPath.item, count = flickrPhotos?.count {
            if item == count - 1 {
                splitView.collectionViewWillDisplayLastItem()
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /*
            Calculate the location of the Photo Cell in the window
            This is used to animate the full screen Photo View
        */
        let rect = collectionView.layoutAttributesForItem(at: indexPath)?.frame
        let cellFrame = collectionView.convert(rect!, to: collectionView.superview)
        
        if let flickrPhoto = flickrPhotos?[indexPath.item!] {
            let view = FullScreenView()
            view.show(flickrPhoto: flickrPhoto, withIntialRect: cellFrame)
        }
    }
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Custom Methods
    //----------------------------------------------------------------------------------------
    func reload() {
        refresher.endRefreshing()
        splitView.reset()
    }
}
