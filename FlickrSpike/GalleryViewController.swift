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
            tableView.reloadData()
        }
    }
    
    //MARK: Variables
    var viewModel: GalleryViewModel!
    
    lazy var tableView: UITableView = {
        var tv = UITableView(frame: CGRect.zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = UITableViewAutomaticDimension
        tv.estimatedRowHeight = MainScreen.Size.width
        tv.separatorStyle = .none
        tv.register(FlickrPhotoTableViewCell.self, forCellReuseIdentifier: "flickrPhotoTableViewCell")
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = GalleryViewModel(delegate: self)
        fetchRecentPhotosFromFlickr()
        
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(tableView)
        tableView.leftAnchor.constraint     (equalTo: view.leftAnchor)  .isActive = true
        tableView.rightAnchor.constraint    (equalTo: view.rightAnchor) .isActive = true
        tableView.topAnchor.constraint      (equalTo: view.topAnchor)   .isActive = true
        tableView.bottomAnchor.constraint   (equalTo: view.bottomAnchor).isActive = true
    }
    
    func fetchRecentPhotosFromFlickr() {
        viewModel.fetchRecentImagesFromFlickr { (loadedPhotos, error) in
            DispatchQueue.main.async {
                self.flickrPhotos = loadedPhotos
            }
        }
    }
}


extension GalleryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = FlickrPhotoTableHeaderView()
        view.flickrPhoto = flickrPhotos?[section]
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return flickrPhotos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flickrPhotoTableViewCell") as! FlickrPhotoTableViewCell
        cell.flickrPhoto = flickrPhotos?[indexPath.section]
        return cell
    }
}
