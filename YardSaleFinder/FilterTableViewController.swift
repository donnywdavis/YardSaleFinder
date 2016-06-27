//
//  FilterTableViewController.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/27/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {

    // MARK: Properties
    
    var selectedRange: MileageRange?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        setSelectedRow(selectedRange!.hashValue)
    }
    
    func setSelectedRow(row: Int) {
        let cell1 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        let cell2 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))
        let cell3 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0))
        let cell4 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0))
        let cell5 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 0))
        
        cell1?.accessoryType = .None
        cell2?.accessoryType = .None
        cell3?.accessoryType = .None
        cell4?.accessoryType = .None
        cell5?.accessoryType = .None
        
        
        switch row {
        case 0:
            cell1?.accessoryType = .Checkmark
            selectedRange = MileageRange.FiveMiles
        case 1:
            cell2?.accessoryType = .Checkmark
            selectedRange = MileageRange.TenMiles
        case 2:
            cell3?.accessoryType = .Checkmark
            selectedRange = MileageRange.FifteenMiles
        case 3:
            cell4?.accessoryType = .Checkmark
            selectedRange = MileageRange.TwentyMiles
        case 4:
            cell5?.accessoryType = .Checkmark
            selectedRange = MileageRange.TwentyFiveMiles
        default:
            selectedRange = nil
        }
        
    }
    
    // MARK: Table View Delegates
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            setSelectedRow(indexPath.row)
        }
    }

}

// MARK: Button Actions

extension FilterTableViewController {
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}