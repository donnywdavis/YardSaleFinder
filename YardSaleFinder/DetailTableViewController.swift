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

class DetailTableViewController: UITableViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    
    // MARK: Properties
    
    var yardSaleID: String?
    var yardSale: YardSale?
    
    var bookmarkUncheckedBarButtonItem: UIBarButtonItem?
    var bookmarkCheckedBarButtonItem: UIBarButtonItem?
    
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
        
        if DataServices.yardSaleIsBookmarked(yardSale.id!) {
            navigationItem.rightBarButtonItem = bookmarkCheckedBarButtonItem
        } else {
            navigationItem.rightBarButtonItem = bookmarkUncheckedBarButtonItem
        }
        
        mapView.addAnnotation(yardSale.annotation!)
        centerOnLocation(CLLocation(latitude: yardSale.location!.latitude, longitude: yardSale.location!.longitude))
        addressLabel.text = yardSale.address?.multiLineDescription
        dateLabel.text = yardSale.formattedDate
        timeLabel.text = yardSale.formattedTime
        itemsLabel.text = yardSale.items
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
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
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
