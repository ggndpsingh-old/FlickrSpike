//
//  FlickrPhotoTableView.swift
//  FlickrPhoto
//
//  Created by Gagandeep Singh on 11/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit


/*
 
    Main Table view that displays Photos inside the Split View
 
 */



public class FlickrPhotoTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    

    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Data
    //----------------------------------------------------------------------------------------
    var flickrPhotos: [FlickrPhoto]? {
        didSet {
            reloadData()
        }
    }
    
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
            static let PhotoCell    = "flickrPhotoTableViewCell"
            static let DataCell     = "flickrPhotoDataCell"
        }
    }
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Variables
    //----------------------------------------------------------------------------------------
    var splitView: FlickrPhotoSplitView!
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Initializers
    //----------------------------------------------------------------------------------------
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        separatorStyle = .none
        
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = MainScreen.Size.width + 60
        
        //register FlickrPhoto Cell
        register(FlickrPhotoTableViewCell.self, forCellReuseIdentifier: Constants.CellIds.PhotoCell)
        register(FlickrPhotoDataCell.self, forCellReuseIdentifier: Constants.CellIds.DataCell)
        
        //Set delegate & data source
        delegate = self
        dataSource = self
        
        addSubview(refresher)
        reloadData()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Table View Delegae & Data Source
    //----------------------------------------------------------------------------------------
    
    
    //----------------------------------------------------------------------------------------
    ///MARK:- Height for header
    //----------------------------------------------------------------------------------------
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    //----------------------------------------------------------------------------------------
    ///MARK:- View for header
    //----------------------------------------------------------------------------------------
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = FlickrPhotoTableHeaderView()
        view.flickrPhoto = flickrPhotos?[section]
        view.tableView = self
        view.indexPath = IndexPath(row: 0, section: section)
        return view
    }
    
    
    //----------------------------------------------------------------------------------------
    ///MARK:- Number of Sections
    //----------------------------------------------------------------------------------------
    public func numberOfSections(in tableView: UITableView) -> Int {
        return flickrPhotos?.count ?? 0
    }
    
    
    //----------------------------------------------------------------------------------------
    ///MARK:- Number of rows
    //----------------------------------------------------------------------------------------
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    //----------------------------------------------------------------------------------------
    ///MARK:- Cell for row at index path
    //----------------------------------------------------------------------------------------
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {     // Photo Cell
            let cell = dequeueReusableCell(withIdentifier: Constants.CellIds.PhotoCell) as! FlickrPhotoTableViewCell
            cell.tableView = self
            cell.indexPath = indexPath
            cell.tag = indexPath.section
            cell.flickrPhoto = flickrPhotos![indexPath.section]
            
            return cell
            
        } else {    //Data Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIds.DataCell) as! FlickrPhotoDataCell
            cell.flickrPhoto = flickrPhotos![indexPath.section]
            
            return cell
        }
        
    }
    
    
    
    //----------------------------------------------------------------------------------------
    ///MARK:- Will display cell at index path
    //----------------------------------------------------------------------------------------
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == flickrPhotos!.count - 1 {
            splitView.tableViewWillDisplayLastItem()
        }
    }
    
    
    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Custom Methods
    //----------------------------------------------------------------------------------------
    
    /*
        Method to be passed on to the Split View Delegate, to show Image Options ActionSheet
     */
    func showImagesOptions(forFlickrPhoto flickrPhoto: FlickrPhoto, atIndexPath indexPath: IndexPath) {
        
        if let PhotoCell = cellForRow(at: indexPath) as? FlickrPhotoTableViewCell {
            if let image = PhotoCell.photoView.image {
                
                splitView.showOptionsForFlickrPhoto(flickrPhoto: flickrPhoto, withImageFile: image, atIndexPath: indexPath)
            }
        }
    }
    
    /*
        Method to be passed on to the Split View Delegate with user information to show user photos
     */
    func showUserPhotos(forUser user: String, withUsername username: String) {
        splitView.showUserPhotos(forUser: user, withUsername: username)
    }
    
    /*
        Method to be passed on to the Split View Delegate to reload all data
     */
    func reload() {
        refresher.endRefreshing()
        splitView.reset()
    }
}
