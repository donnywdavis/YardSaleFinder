//
//  MapViewController.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/10/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import Gloss

class MapViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties
    
    let locationManager = CLLocationManager()
    var yardSales = [String: YardSale]()
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }

        self.listenForEvents()

    }
    
    override func viewWillDisappear(animated: Bool) {
        DataReference.sharedInstance.activeYardSalesRef.removeAllObservers()
        DataReference.sharedInstance.yardSalesRef.removeAllObservers()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}

// MARK: Button Actions

extension MapViewController {
    
    @IBAction func currentLocationButtonPressed(sender: UIBarButtonItem) {
        if let location = mapView.userLocation.location {
            centerOnLocation(location)
        }
    }
    
}

// MARK: Firebase Methods

extension MapViewController {

    func listenForEvents() {
        // List for any new yard sales being added
        DataReference.sharedInstance.activeYardSalesRef.observeEventType(.ChildAdded) { (activeKeys: FIRDataSnapshot) in
            DataReference.sharedInstance.yardSalesRef.child(activeKeys.key).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
                let yardSale = YardSale(json: snapshot.value as! JSON)
                self.yardSales[snapshot.key] = yardSale
                self.mapView.addAnnotation((yardSale?.annotation)!)
            }
        }
        
        // Remove a yard sale from the map
        DataReference.sharedInstance.activeYardSalesRef.observeEventType(.ChildRemoved) { (snapshot: FIRDataSnapshot) in
            let yardSale = self.yardSales[snapshot.key]
            self.yardSales.removeValueForKey(snapshot.key)
            self.mapView.removeAnnotation((yardSale?.annotation)!)
        }
    }
    
}

// MARK: Map Functions

extension MapViewController: MKMapViewDelegate {

    func centerOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
        mapView.setRegion(coordinateRegion, animated: true)
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
        pin?.canShowCallout = true
        pin?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        
        return pin
    }
    
}
