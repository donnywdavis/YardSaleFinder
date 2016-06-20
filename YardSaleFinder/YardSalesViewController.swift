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
        
        if let yardSales = DataServices.usersYardSales {
            self.yardSales = yardSales
        }
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
        
        cell.textLabel?.text = NSDateFormatter.localizedStringFromDate(yardSale.startTime!, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        
        return cell
    }
    
}
