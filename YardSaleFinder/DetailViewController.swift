//
//  DetailViewController.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/13/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit
import Firebase
import Gloss

enum TableCellsReference {
    case MapCell
    case AddressCell
    case DateCell
    case TimeCell
    case PriceRangeCell
    case ItemsCell
}

class DetailViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    var yardSaleID: String?
    var yardSale: YardSale?
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500.0
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
        navigationController?.toolbarHidden = true
        navigationController?.hidesBarsOnTap = false
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        if let yardSaleID = yardSaleID {
            DataReference.sharedInstance.yardSalesRef.child(yardSaleID).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
                self.yardSale = YardSale(json: snapshot.value as! JSON)
                self.tableView.reloadData()
            }
        }
    }

}

// MARK: Table View Delegates and DataSource

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        guard let yardSale = yardSale else {
            return cell
        }
        
        switch indexPath.row {
        case TableCellsReference.MapCell.hashValue:
            if let mapCell = tableView.dequeueReusableCellWithIdentifier("MapCell", forIndexPath: indexPath) as? MapTableViewCell {
                mapCell.configureCell(yardSale)
                cell = mapCell
            }
            
        case TableCellsReference.AddressCell.hashValue:
            if let addressCell = tableView.dequeueReusableCellWithIdentifier("AddressCell", forIndexPath: indexPath) as? AddressTableViewCell {
                addressCell.configureCell(yardSale)
                cell = addressCell
            }
            
        case TableCellsReference.DateCell.hashValue:
            if let dateCell = tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath) as? DateTableViewCell {
                dateCell.configureCell(yardSale)
                cell = dateCell
            }
            
        case TableCellsReference.TimeCell.hashValue:
            if let timeCell = tableView.dequeueReusableCellWithIdentifier("TimeCell", forIndexPath: indexPath) as? TimeTableViewCell {
                timeCell.configureCell(yardSale)
                cell = timeCell
            }
            
        case TableCellsReference.PriceRangeCell.hashValue:
            if let priceRangeCell = tableView.dequeueReusableCellWithIdentifier("PriceRangeCell", forIndexPath: indexPath) as? PriceRangeTableViewCell {
                priceRangeCell.configureCell(yardSale)
                cell = priceRangeCell
            }
            
        case TableCellsReference.ItemsCell.hashValue:
            if let itemsCell = tableView.dequeueReusableCellWithIdentifier("ItemsCell", forIndexPath: indexPath) as? ItemsTableViewCell {
                itemsCell.configureCell(yardSale)
                cell = itemsCell
            }
            
        default:
            break
        }
    
        return cell
    }
    
}
