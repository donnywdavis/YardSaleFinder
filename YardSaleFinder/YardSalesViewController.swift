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

        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        
        loadYardSales()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }

}

// MARK: Table View Delegates

extension YardSalesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yardSales.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("YardSaleCell", forIndexPath: indexPath)
        
        let yardSale = yardSales[indexPath.row]
        
        cell.textLabel?.text = dateFormatter.stringFromDate(yardSale.fromTime!)
        
        return cell
    }
    
}

// MARK: Firebase Methods

extension YardSalesViewController {
    
    func loadYardSales() {
        DataReference.sharedInstance.usersRef.child((DataServices.userProfile?.id)!).child("yardSales").observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            if let values = snapshot.value as? [String: Bool] {
                for key in values.keys {
                    DataReference.sharedInstance.yardSalesRef.child(key).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
                        self.yardSales.append(YardSale(json: snapshot.value as! JSON)!)
                        self.tableView.reloadData()
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
}