//
//  DetailTableViewController.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/23/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import Gloss

class DetailTableViewController: UITableViewController, ImageHandler {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Properties
    
    var yardSaleID: String?
    var yardSale: YardSale?
    
    var bookmarkUncheckedBarButtonItem: UIBarButtonItem?
    var bookmarkCheckedBarButtonItem: UIBarButtonItem?
    
    var itemImages = [Photo]()
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookmarkCheckedBarButtonItem = UIBarButtonItem(image: UIImage(named: "bookmark_checked"), style: .Plain, target: self, action: #selector(bookmarkItem(_:)))
        bookmarkUncheckedBarButtonItem = UIBarButtonItem(image: UIImage(named: "bookmark_unchecked"), style: .Plain, target: self, action: #selector(bookmarkItem(_:)))

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        if let yardSaleID = yardSaleID {
            DataReference.sharedInstance.yardSalesRef.child(yardSaleID).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
                self.yardSale = YardSale(json: snapshot.value as! JSON)
                self.loadYardSaleDetail()
                self.tableView.reloadData()
            }
        }
    }
    
    func loadYardSaleDetail() {
        guard let yardSale = yardSale else {
            return
        }
        
        if DataServices.isUserLoggedIn() {
            if DataServices.yardSaleIsBookmarked(yardSale.id!) {
                navigationItem.rightBarButtonItem = bookmarkCheckedBarButtonItem
            } else {
                navigationItem.rightBarButtonItem = bookmarkUncheckedBarButtonItem
            }
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        
        mapView.addAnnotation(yardSale.annotation!)
        centerOnLocation(CLLocation(latitude: yardSale.location!.latitude, longitude: yardSale.location!.longitude))
        addressLabel.text = yardSale.address?.multiLineDescription
        dateLabel.text = yardSale.formattedDate
        timeLabel.text = yardSale.formattedTime
        itemsLabel.text = yardSale.items
        
        if yardSale.photos != nil {
            downloadImages(yardSale) { (photo, error) in
                guard error == nil else {
                    return
                }
                
                if let photo = photo {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.itemImages.append(photo)
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }

}

// MARK: Button Actions

extension DetailTableViewController {
    
    func bookmarkItem(sender: UIBarButtonItem) {
        guard let yardSaleID = yardSale?.id else {
            return
        }
        
        switch sender {
        case bookmarkCheckedBarButtonItem!:
            DataServices.bookmarkForUser(yardSaleID, action: BookmarkActions.Remove)
            navigationItem.rightBarButtonItem = bookmarkUncheckedBarButtonItem
            
        case bookmarkUncheckedBarButtonItem!:
            DataServices.bookmarkForUser(yardSaleID, action: BookmarkActions.Add)
            navigationItem.rightBarButtonItem = bookmarkCheckedBarButtonItem
            
        default:
            return
        }
    }
    
}

// MARK: Table View Data Source

extension DetailTableViewController {
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 5:
            return 100.0
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let title = UILabel()
        title.textColor = UIColor(red: 0/255.0, green: 178/255.0, blue: 51/255.0, alpha: 1.0)
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = title.textColor
        header.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.0
        default:
            return 25.0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Address"
            
        case 2:
            return "Date"
            
        case 3:
            return "Time"
            
        case 4:
            return "Items"
            
        case 5:
            return "Photos"
            
        default:
            return nil
        }
    }
    
}

// MARK: Map Functions

extension DetailTableViewController: MKMapViewDelegate {
    
    func centerOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 100, 100)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        let yardSaleAnnotation = annotation as! Annotation
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier("YardSalePin")
        if pin == nil {
            pin = MKAnnotationView(annotation: yardSaleAnnotation, reuseIdentifier: "YardSalePin")
        } else {
            pin?.annotation = yardSaleAnnotation
        }
        
        pin?.image = UIImage(named: "salesSign")
        pin?.canShowCallout = false
        
        return pin
    }
    
}

// MARK: Collection View Delegates

extension DetailTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = yardSale?.photos?.count else {
            return 0
        }

        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! ItemCollectionViewCell
        
        if indexPath.row > itemImages.count - 1 {
            cell.activityIndicator.startAnimating()
            cell.itemImage.hidden = true
        } else {
            cell.itemImage.hidden = false
            cell.activityIndicator.stopAnimating()
            let photo = itemImages[indexPath.row]
            cell.itemImage.image = photo.image
        }
        
        return cell
    }
    
}
