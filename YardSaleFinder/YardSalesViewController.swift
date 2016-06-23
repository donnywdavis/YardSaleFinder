//
//  YardSalesViewController.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/17/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit
import Firebase
import Gloss

class YardSalesViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    var yardSales = [YardSale]()
    let dateFormatter = NSDateFormatter()
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        DataServices.getYardSalesForOwner(DataServices.currentUser!.uid, success: { (yardSales) in
            self.yardSales = yardSales!
            self.tableView.reloadData()
            }, failure: { (error) in
                self.yardSales = [YardSale]()
                self.tableView.reloadData()
        })
    }

}

// MARK: Table View Delegates

extension YardSalesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yardSales.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("YardSaleCell", forIndexPath: indexPath) as! YardSaleDateTableViewCell
        
        let yardSale = yardSales[indexPath.row]
        
        cell.configureCell(yardSale.formattedDateTime)
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

// MARK: Navigation

extension YardSalesViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "YardSaleDetailSegue" {
            if let yardSaleDetailVC = segue.destinationViewController as? YardSaleDetailTableViewController, let indexPath = tableView.indexPathForSelectedRow {
                yardSaleDetailVC.yardSale = yardSales[indexPath.row]
            }
        }
    }
    
    @IBAction func unwindToYardSalesList(segue: UIStoryboardSegue) {
    }
    
}
