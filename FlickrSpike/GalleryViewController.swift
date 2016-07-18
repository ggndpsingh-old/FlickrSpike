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
//            tableView.reloadData()
            collectionView.reloadData()
        }
    }
    
    //MARK: Variables
    var viewModel: GalleryViewModel!
    var pagesLoaded = 0
    
    lazy var tableView: UITableView = {
        var tv = UITableView(frame: CGRect.zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = UITableViewAutomaticDimension
        tv.estimatedRowHeight = MainScreen.Size.width
        tv.separatorStyle = .none
        tv.register(FlickrPhotoTableViewCell.self, forCellReuseIdentifier: "flickrPhotoTableViewCell")
        tv.register(FlickrPhotoDataCell.self, forCellReuseIdentifier: "flickrPhotoDataCell")
        return tv
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white()
        cv.delegate = self
        cv.dataSource = self
        cv.register(FlickrPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "flickrPhotoCollectionViewCell")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = GalleryViewModel(delegate: self)
        fetchRecentPhotosFromFlickr()
        
        setupViews()
    }
    
    func setupViews() {
//        view.addSubview(tableView)
//        tableView.leftAnchor.constraint     (equalTo: view.leftAnchor)  .isActive = true
//        tableView.rightAnchor.constraint    (equalTo: view.rightAnchor) .isActive = true
//        tableView.topAnchor.constraint      (equalTo: view.topAnchor)   .isActive = true
//        tableView.bottomAnchor.constraint   (equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(collectionView)
        collectionView.leftAnchor.constraint     (equalTo: view.leftAnchor)  .isActive = true
        collectionView.rightAnchor.constraint    (equalTo: view.rightAnchor) .isActive = true
        collectionView.topAnchor.constraint      (equalTo: view.topAnchor)   .isActive = true
        collectionView.bottomAnchor.constraint   (equalTo: view.bottomAnchor).isActive = true
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let flickrPhoto = flickrPhotos?[indexPath.section]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "flickrPhotoTableViewCell") as! FlickrPhotoTableViewCell
            cell.flickrPhoto = flickrPhoto
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "flickrPhotoDataCell") as! FlickrPhotoDataCell
            cell.flickrPhoto = flickrPhoto
            return cell
        }
    }
}



extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrPhotos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "flickrPhotoCollectionViewCell", for: indexPath) as! FlickrPhotoCollectionViewCell
        cell.flickrPhoto = flickrPhotos?[indexPath.item!]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let distance = 2 / MainScreen.Scale
        return CGSize(width: (MainScreen.Size.width / 3) - distance, height: (MainScreen.Size.width / 3) - distance)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let item = indexPath.item, count = flickrPhotos?.count {
            if item == count - 1 {
                fetchRecentPhotosFromFlickr()
            }
        }
    }
}
