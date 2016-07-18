//
//  FlickrPhotoTableView.swift
//  FlickrPhoto
//
//  Created by Gagandeep Singh on 11/7/16.
//  Copyright © 2016 Gagandeep Singh. All rights reserved.
//

import UIKit

public class FlickrPhotoTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    

    //----------------------------------------------------------------------------------------
    //MARK:
    //MARK: Variables
    //----------------------------------------------------------------------------------------
    var flickrPhotos: [FlickrPhoto]? {
        didSet {
            reloadData()
        }
    }
    
    lazy public var refresher: UIRefreshControl! = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(reload), for: .valueChanged)
        return rc
    }()
    
    
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
        register(FlickrPhotoTableViewCell.self, forCellReuseIdentifier: "flickrPhotoTableViewCell")
        register(FlickrPhotoDataCell.self, forCellReuseIdentifier: "flickrPhotoDataCell")
        
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
        
        if indexPath.row == 0 {
            let cell = dequeueReusableCell(withIdentifier: "flickrPhotoTableViewCell") as! FlickrPhotoTableViewCell
            cell.flickrPhoto = flickrPhotos![indexPath.section]
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "flickrPhotoDataCell") as! FlickrPhotoDataCell
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
    func showImagesOptions(forFlickrPhoto flickrPhoto: FlickrPhoto, andImage: UIImage) {
        
    }
    
    func scrollToItemSelectedInCollectionView(at index: Int) {
        let delayTime = DispatchTime.now() + 0.3
        DispatchQueue.main.after(when: delayTime) {
            
            let indexPath = IndexPath(row: 0, section: index)
            self.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func reload() {
        refresher.endRefreshing()
        splitView.reset()
    }
}
