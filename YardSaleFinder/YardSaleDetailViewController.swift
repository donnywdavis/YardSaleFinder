//
//  YardSaleDetailViewController.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/17/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit
import MapKit

class YardSaleDetailTableViewController: UITableViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var street1TextField: UITextField!
    @IBOutlet weak var street2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    // MARK: Properties
    
    var isDatePickerVisible = false
    var isStartTimePickerVisible = false
    var isEndTimePickerVisible = false
    
    var doneBarButtonItem: UIBarButtonItem?
    var cancelBarButtonItem: UIBarButtonItem?
    var saveBarButtonItem: UIBarButtonItem?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(cancelDoneButtonTapped(_:)))
        cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancelDoneButtonTapped(_:)))
        saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(saveButtonTapped(_:)))
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = saveBarButtonItem
        
        datePicker.minimumDate = NSDate()
        startTimePicker.minimumDate = NSDate()
        endTimePicker.minimumDate = NSDate()

        tableView.tableFooterView = UIView(frame: CGRectZero)
    }

}

// MARK: Table View Delegates

extension YardSaleDetailTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            toggleDateTimePicker(indexPath.row)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                updateDateTimeLabel(cell, row: indexPath.row)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

// MARK: Table View Data Sources

extension YardSaleDetailTableViewController {
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 30.0))
        headerView.backgroundColor = UIColor(red: 0/255.0, green: 178/255.0, blue: 51/255.0, alpha: 1.0)
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Location"
            
        case 1:
            return "Date/Time"
            
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (1, 1) where !isDatePickerVisible:
            return 0
            
        case (1, 3) where !isStartTimePickerVisible:
            return 0
            
        case (1, 5) where !isEndTimePickerVisible:
            return 0
            
        default:
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
}

// MARK: Date/Time Pickers Functions

extension YardSaleDetailTableViewController {
    
    func toggleDateTimePicker(row: Int) {
        switch row {
        case 0:
            isDatePickerVisible = !isDatePickerVisible
            isStartTimePickerVisible = false
            isEndTimePickerVisible = false
            
        case 2:
            isStartTimePickerVisible = !isStartTimePickerVisible
            isDatePickerVisible = false
            isEndTimePickerVisible = false
            
        case 4:
            isEndTimePickerVisible = !isEndTimePickerVisible
            isDatePickerVisible = false
            isStartTimePickerVisible = false
            
        default:
            return
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func updateDateTimeLabel(cell: UITableViewCell, row: Int) {
        switch row {
        case 0:
            cell.detailTextLabel?.text = NSDateFormatter.localizedStringFromDate(datePicker.date, dateStyle: .MediumStyle, timeStyle: .NoStyle)
            startTimePicker.date = datePicker.date
            endTimePicker.date = datePicker.date
            
        case 2:
            cell.detailTextLabel?.text = NSDateFormatter.localizedStringFromDate(startTimePicker.date, dateStyle: .NoStyle, timeStyle: .ShortStyle)
            
        case 4:
            cell.detailTextLabel?.text = NSDateFormatter.localizedStringFromDate(endTimePicker.date, dateStyle: .NoStyle, timeStyle: .ShortStyle)
            
        default:
            return
        }
    }
    
    @IBAction func dateSelection(sender: UIDatePicker) {
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1)) {
            updateDateTimeLabel(cell, row: 0)
        }
    }
    
    @IBAction func startTimeSelection(sender: UIDatePicker) {
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 1)) {
            updateDateTimeLabel(cell, row: 2)
        }
    }
    
    @IBAction func endTimeSelection(sender: UIDatePicker) {
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 5, inSection: 1)) {
            updateDateTimeLabel(cell, row: 4)
        }
    }
    
}

// MARK: Button Actions

extension YardSaleDetailTableViewController {
    
    @IBAction func cancelDoneButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        var newYardSale = YardSale()
        if let street1 = street1TextField.text {
            newYardSale.address = "\(street1):"
        }
        if let street2 = street2TextField.text {
            newYardSale.address = "\(newYardSale.address!)\(street2):"
        }
        if let city = cityTextField.text {
            newYardSale.address = "\(newYardSale.address!)\(city), "
        }
        if let state = stateTextField.text {
            newYardSale.address = "\(newYardSale.address!)\(state) "
        }
        if let zipCode = zipCodeTextField.text {
            newYardSale.address = "\(newYardSale.address!)\(zipCode)"
        }
        newYardSale.startTime = startTimePicker.date
        newYardSale.endTime = endTimePicker.date
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(newYardSale.address!) { (placemarks, error) in
            let placemark = placemarks?.last
            newYardSale.location = CLLocationCoordinate2DMake((placemark?.location?.coordinate.latitude)!, (placemark?.location?.coordinate.longitude)!)
            DataServices.addNewYardSale(newYardSale)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
}
