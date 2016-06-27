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
import GeoFire

enum MileageRange: Int {
    case FiveMiles = 5
    case TenMiles = 10
    case FifteenMiles = 15
    case TwentyMiles = 20
    case TwentyFiveMiles = 25
}

class MapViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var mileageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchTextField: UITextField!
    
    // MARK: Properties
    
    let locationManager = CLLocationManager()
    var yardSales = [String: YardSale]()
    var selectedYardSale: String?
    var mileageSegmentedControlIsHidden = true
    var yardSaleQuery: GFCircleQuery?
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        searchTextField.delegate = self
        addDoneButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        mileageSegmentedControl.center.y -= self.view.bounds.width
        
        setProfileButtonImage()
    }
    
    override func viewWillDisappear(animated: Bool) {
        yardSaleQuery?.removeAllObservers()
//        DataReference.sharedInstance.activeYardSalesRef.removeAllObservers()
//        DataReference.sharedInstance.yardSalesRef.removeAllObservers()
        
    }

}

// MARK: Navigation

extension MapViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailVC = segue.destinationViewController as? DetailTableViewController {
            detailVC.yardSaleID = selectedYardSale
        }
    }
    
    @IBAction func unwindToMapViewController(segue: UIStoryboardSegue) {
        setProfileButtonImage()
    }
    
}

// MARK: Button Actions

extension MapViewController {
    
    @IBAction func profileButtonTapped(sender: UIButton) {
        if DataServices.currentUser != nil {
            self.performSegueWithIdentifier("MapToProfileSegue", sender: nil)
        } else {
            self.performSegueWithIdentifier("MapToSignInSegue", sender: nil)
        }
    }
    
    @IBAction func currentLocationButtonPressed(sender: UIBarButtonItem) {
        locationManager.requestLocation()
    }
    
    @IBAction func showMileageSegmentedControl(sender: UIBarButtonItem) {
        if mileageSegmentedControlIsHidden {
            UIView.animateWithDuration(0.3) {
                self.mileageSegmentedControl.center.y += self.view.bounds.width
            }
        } else {
            UIView.animateWithDuration(0.3) {
                self.mileageSegmentedControl.center.y -= self.view.bounds.width
            }
        }
        
        mileageSegmentedControlIsHidden = !mileageSegmentedControlIsHidden
    }
    
}

// MARK: Text Field Delegates

extension MapViewController: UITextFieldDelegate {
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
                                            target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        searchTextField.inputAccessoryView = keyboardToolbar
    }
    
    @IBAction func dismissKeyboard() {
        searchTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let searchText = textField.text else {
            return false
        }
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(searchText) { (placemarks, error) in
            let placemark = placemarks?.last
            if let location = placemark?.location {
                self.mapView.removeAnnotations(self.yardSales.flatMap { $0.1.annotation })
                self.centerOnLocation(location, range: MileageRange.TenMiles)
                self.listenForEvents(MileageRange.TenMiles, location: location)
            }
        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
}

// MARK: Utility Methods

extension MapViewController {
    
    func setProfileButtonImage() {
        if DataServices.isUserLoggedIn() && DirectoryServices.profileImageExists() {
            profileButton.layer.cornerRadius = profileButton.frame.size.width / 2
            profileButton.layer.borderWidth = 2.0
            profileButton.layer.borderColor = UIColor.whiteColor().CGColor
            profileButton.clipsToBounds = true
            profileButton.setImage(UIImage(contentsOfFile: DirectoryServices.getImagePath()), forState: .Normal)
        } else {
            profileButton.setImage(UIImage(named: "profile32"), forState: .Normal)
        }
    }
    
    @IBAction func mileageSegmentedControlChanged(sender: UISegmentedControl) {
        
        mapView.removeAnnotations(yardSales.flatMap { $0.1.annotation })
        
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        switch sender.selectedSegmentIndex {
        case MileageRange.FiveMiles.hashValue:
            centerOnLocation(location, range: MileageRange.FiveMiles)
            listenForEvents(MileageRange.FiveMiles, location: location)
            
        case MileageRange.TenMiles.hashValue:
            centerOnLocation(location, range: MileageRange.TenMiles)
            listenForEvents(MileageRange.TenMiles, location: location)
            
        case MileageRange.FifteenMiles.hashValue:
            centerOnLocation(location, range: MileageRange.FifteenMiles)
            listenForEvents(MileageRange.FifteenMiles, location: location)
            
        case MileageRange.TwentyMiles.hashValue:
            centerOnLocation(location, range: MileageRange.TwentyMiles)
            listenForEvents(MileageRange.TwentyFiveMiles, location: location)
            
        case MileageRange.TwentyFiveMiles.hashValue:
            centerOnLocation(location, range: MileageRange.TwentyFiveMiles)
            listenForEvents(MileageRange.TwentyFiveMiles, location: location)

        default:
            return
        }
        
    }
    
}

// MARK: Firebase Methods

extension MapViewController {

    func listenForEvents(range: MileageRange, location: CLLocation) {
        
        yardSaleQuery?.removeAllObservers()
        
        let radius = Double(range.rawValue) / 0.62137119
        
        yardSaleQuery = DataReference.sharedInstance.geoFireRef.queryAtLocation(location, withRadius: radius)
        
        yardSaleQuery?.observeEventType(.KeyEntered) { (key, location) in
            DataServices.getRemoteYardSaleInfo(key, completion: { (yardSale) in
                self.yardSales[yardSale!.id!] = yardSale
                self.mapView.addAnnotation((yardSale?.annotation)!)
            })
        }
        
        yardSaleQuery?.observeEventType(.KeyExited) { (key, location) in
            guard self.yardSales[key] != nil else {
                return
            }
            let yardSale = self.yardSales[key]
            self.yardSales.removeValueForKey(key)
            self.mapView.removeAnnotation((yardSale?.annotation)!)
        }
        
        // List for any new yard sales being added
//        DataReference.sharedInstance.activeYardSalesRef.observeEventType(.ChildAdded) { (activeKeys: FIRDataSnapshot) in
//            DataReference.sharedInstance.yardSalesRef.child(activeKeys.key).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
//                let yardSale = YardSale(json: snapshot.value as! JSON)
//                self.yardSales[snapshot.key] = yardSale
//                self.mapView.addAnnotation((yardSale?.annotation)!)
//            }
//        }
        
        // Remove a yard sale from the map
//        DataReference.sharedInstance.activeYardSalesRef.observeEventType(.ChildRemoved) { (snapshot: FIRDataSnapshot) in
//            let yardSale = self.yardSales[snapshot.key]
//            self.yardSales.removeValueForKey(snapshot.key)
//            self.mapView.removeAnnotation((yardSale?.annotation)!)
//        }
    }
    
}

// MARK: Map Functions

extension MapViewController: MKMapViewDelegate {

    func centerOnLocation(location: CLLocation, range: MileageRange) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, (Double(range.rawValue) / 0.00062137), (Double(range.rawValue) / 0.00062137))
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
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        selectedYardSale = (view.annotation as! Annotation).id
        performSegueWithIdentifier("MapToDetailSegue", sender: self)
    }
    
}

// MARK: Location Manager Delegates

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            switch mileageSegmentedControl.selectedSegmentIndex {
            case MileageRange.FiveMiles.hashValue:
                centerOnLocation(location, range: MileageRange.FiveMiles)
                listenForEvents(MileageRange.FiveMiles, location: location)
                
            case MileageRange.TenMiles.hashValue:
                centerOnLocation(location, range: MileageRange.TenMiles)
                listenForEvents(MileageRange.TenMiles, location: location)
                
            case MileageRange.FifteenMiles.hashValue:
                centerOnLocation(location, range: MileageRange.FifteenMiles)
                listenForEvents(MileageRange.FifteenMiles, location: location)
                
            case MileageRange.TwentyMiles.hashValue:
                centerOnLocation(location, range: MileageRange.TwentyMiles)
                listenForEvents(MileageRange.TwentyFiveMiles, location: location)
                
            case MileageRange.TwentyFiveMiles.hashValue:
                centerOnLocation(location, range: MileageRange.TwentyFiveMiles)
                listenForEvents(MileageRange.TwentyFiveMiles, location: location)
                
            default:
                return
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if error != "" {
            print("Location Error: \(error)")
        }
    }
    
}
