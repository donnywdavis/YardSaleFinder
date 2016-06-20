//
//  MapTableViewCell.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/13/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties
    
    
    // MARK: View Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: Cell Configuration

extension MapTableViewCell {
    
    func configureCell(yardSale: YardSale) {
        mapView.addAnnotation(yardSale.annotation!)
        centerOnLocation(CLLocation(latitude: yardSale.location!.latitude, longitude: yardSale.location!.longitude))
    }
    
}

// MARK: Map Functions

extension MapTableViewCell: MKMapViewDelegate {
    
    func centerOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 300, 300)
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
