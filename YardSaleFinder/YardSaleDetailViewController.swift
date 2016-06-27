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
    
    @IBOutlet weak var activeSwitch: UISwitch!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var aptSuiteTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var itemsTextView: UITextView!
    
    // MARK: Properties
    
    let dateFormatter = NSDateFormatter()
    
    var yardSale: YardSale?
    var isDatePickerVisible = false
    var isStartTimePickerVisible = false
    var isEndTimePickerVisible = false
    
    var saveBarButtonItem: UIBarButtonItem?
    var updatingBarButtonItem: UIBarButtonItem?
    var activityIndicator = UIActivityIndicatorView()
    var statePickerView = UIPickerView()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(saveButtonTapped(_:)))
        updatingBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = saveBarButtonItem
        
        streetTextField.delegate = self
        aptSuiteTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        zipCodeTextField.delegate = self
        
        statePickerView.delegate = self
        statePickerView.showsSelectionIndicator = true
        stateTextField.inputView = statePickerView
        keyboardAccessoryButtons()
        
        datePicker.minimumDate = NSDate()
        startTimePicker.minimumDate = datePicker.date
        endTimePicker.minimumDate = datePicker.date

        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        if let yardSale = yardSale {
            loadDetailData(yardSale)
        } else if DataServices.userProfile?.address != nil {
            streetTextField.text = DataServices.userProfile?.address?.street
            aptSuiteTextField.text = DataServices.userProfile?.address?.aptSuite
            cityTextField.text = DataServices.userProfile?.address?.city
            stateTextField.text = DataServices.userProfile?.address?.state
            zipCodeTextField.text = DataServices.userProfile?.address?.zipCode
        }
    }
    
    func loadDetailData(yardSale: YardSale) {
        if let active = yardSale.active {
            activeSwitch.on = active
        }
        
        streetTextField.text = yardSale.address?.street
        aptSuiteTextField.text = yardSale.address?.aptSuite
        cityTextField.text = yardSale.address?.city
        stateTextField.text = yardSale.address?.state
        zipCodeTextField.text = yardSale.address?.zipCode
        
        datePicker.setDate(yardSale.startTime!, animated: false)
        startTimePicker.setDate(yardSale.startTime!, animated: false)
        endTimePicker.setDate(yardSale.endTime!, animated: false)
        
        itemsTextView.text = yardSale.items
        
        let dateCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))
        let startTimeCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 2))
        let endTimeCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 2))
        
        dateCell?.detailTextLabel?.text = dateFormatter.formatDate(yardSale.startTime)
        startTimeCell?.detailTextLabel?.text = dateFormatter.formatTime(yardSale.startTime)!
        endTimeCell?.detailTextLabel?.text = dateFormatter.formatTime(yardSale.endTime)
    }

}

// MARK: Table View Delegates

extension YardSaleDetailTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
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
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let title = UILabel()
        title.textColor = UIColor.whiteColor()
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = title.textColor
        header.contentView.backgroundColor = UIColor(red: 0/255.0, green: 178/255.0, blue: 51/255.0, alpha: 1.0)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0, 4 where yardSale == nil:
            return 0.0
        case 4:
            return 10.0
        default:
            return 35.0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Location"
            
        case 2:
            return "Date/Time"
            
        case 3:
            return "Items"
            
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (2, 1) where !isDatePickerVisible, (2, 3) where !isStartTimePickerVisible, (2, 5) where !isEndTimePickerVisible, (4, 0) where yardSale == nil:
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
            cell.detailTextLabel?.text = dateFormatter.formatDate(datePicker.date)
            startTimePicker.date = datePicker.date
            endTimePicker.date = datePicker.date
            
        case 2:
            cell.detailTextLabel?.text = dateFormatter.formatTime(startTimePicker.date)
            
        case 4:
            cell.detailTextLabel?.text = dateFormatter.formatTime(endTimePicker.date)
            
        default:
            return
        }
    }
    
    @IBAction func dateSelection(sender: UIDatePicker) {
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) {
            updateDateTimeLabel(cell, row: 0)
        }
    }
    
    @IBAction func startTimeSelection(sender: UIDatePicker) {
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 2)) {
            updateDateTimeLabel(cell, row: 2)
        }
    }
    
    @IBAction func endTimeSelection(sender: UIDatePicker) {
        if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 2)) {
            updateDateTimeLabel(cell, row: 4)
        }
    }
    
}

// MARK: Button Actions

extension YardSaleDetailTableViewController {
    
    @IBAction func cancelDoneButtonTapped(sender: UIBarButtonItem) {
        performSegueWithIdentifier("UnwindToYardSalesList", sender: nil)
    }
    
    @IBAction func deleteButtonTapped(sender: UIButton) {
        DataServices.deleteYardSale(yardSale!) {
            self.performSegueWithIdentifier("UnwindToYardSalesList", sender: nil)
        }
    }
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItem = updatingBarButtonItem
        activityIndicator.startAnimating()
        
        var yardSale = YardSale()
        if let currentYardSale = self.yardSale {
            yardSale = currentYardSale
        }
        
        yardSale.address = Address(street: streetTextField.text, aptSuite: aptSuiteTextField.text, city: cityTextField.text, state: stateTextField.text, zipCode: zipCodeTextField.text)
        yardSale.startTime = startTimePicker.date
        yardSale.endTime = endTimePicker.date
        yardSale.active = activeSwitch.on
        yardSale.items = itemsTextView.text
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(yardSale.address!.oneLineDescription) { (placemarks, error) in
            let placemark = placemarks?.last
            yardSale.location = CLLocationCoordinate2DMake((placemark?.location?.coordinate.latitude)!, (placemark?.location?.coordinate.longitude)!)
            if self.yardSale == nil {
                DataServices.addNewYardSale(yardSale) {
                    self.activityIndicator.stopAnimating()
                    self.performSegueWithIdentifier("UnwindToYardSalesList", sender: nil)
                }
            } else {
                DataServices.updateYardSale(yardSale) {
                    self.activityIndicator.stopAnimating()
                    self.performSegueWithIdentifier("UnwindToYardSalesList", sender: nil)
                }
            }
        }
        
    }
    
}

// MARK: Picker View Delegates

extension YardSaleDetailTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return StateCodes.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let state = StateCodes.getStateCode(row)
        return state.description
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let state = StateCodes.getStateCode(row)
        stateTextField.text = state.shortDescription
    }
    
}

// MARK: Text Field Methods

extension YardSaleDetailTableViewController: UITextFieldDelegate {
    
    func keyboardAccessoryButtons() {
        let stateKeyboardToolbar = UIToolbar()
        let zipItemsKeyboardToolbar = UIToolbar()
        stateKeyboardToolbar.sizeToFit()
        zipItemsKeyboardToolbar.sizeToFit()
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
                                            target: nil, action: nil)
        let nextBarButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(nextButtonTapped))
        let stateDoneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
                                                 target: self, action: #selector(dismissKeyboard))
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
                                               target: self, action: #selector(dismissKeyboard))
        
        nextBarButton.tintColor = UIColor(red: 0/255.0, green: 178/255.0, blue: 51/255.0, alpha: 1.0)
        stateDoneBarButton.tintColor = UIColor(red: 0/255.0, green: 178/255.0, blue: 51/255.0, alpha: 1.0)
        doneBarButton.tintColor = UIColor(red: 0/255.0, green: 178/255.0, blue: 51/255.0, alpha: 1.0)
        
        stateKeyboardToolbar.items = [nextBarButton, flexBarButton, stateDoneBarButton]
        stateTextField.inputAccessoryView = stateKeyboardToolbar
        
        zipItemsKeyboardToolbar.items = [flexBarButton, doneBarButton]
        zipCodeTextField.inputAccessoryView = zipItemsKeyboardToolbar
        itemsTextView.inputAccessoryView = zipItemsKeyboardToolbar
    }
    
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func nextButtonTapped() {
        textFieldShouldReturn(stateTextField)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == stateTextField {
            if let state = stateTextField.text {
                statePickerView.selectRow(StateCodes.getIndexForState(state), inComponent: 0, animated: true)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if streetTextField.isFirstResponder() {
            streetTextField.resignFirstResponder()
            aptSuiteTextField.becomeFirstResponder()
        } else if aptSuiteTextField.isFirstResponder() {
            aptSuiteTextField.resignFirstResponder()
            cityTextField.becomeFirstResponder()
        } else if cityTextField.isFirstResponder() {
            cityTextField.resignFirstResponder()
            stateTextField.becomeFirstResponder()
        } else if stateTextField.isFirstResponder() {
            stateTextField.resignFirstResponder()
            zipCodeTextField.becomeFirstResponder()
        } else if zipCodeTextField.isFirstResponder() {
            zipCodeTextField.resignFirstResponder()
        } else if itemsTextView.isFirstResponder() {
            itemsTextView.resignFirstResponder()
        }
        
        return true
    }
    
}
