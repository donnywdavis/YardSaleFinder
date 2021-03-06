//
//  BookmarksViewController.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/24/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class BookmarksViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    var yardSales = [YardSale]()
    var selectedYardSale: YardSale?
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        if let bookmarks = DataServices.userProfile?.bookmarks {
            yardSales = [YardSale]()
            for bookmark in bookmarks.keys {
                DataServices.getRemoteYardSaleInfo(bookmark, completion: { (yardSale) in
                    guard let yardSale = yardSale else {
                        return
                    }
                    self.yardSales.append(yardSale)
                    self.tableView.reloadData()
                })
            }
        }
    }

}

// MARK: Button Actions

extension BookmarksViewController {
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

// MARK: Table View Data Sources

extension BookmarksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yardSales.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BookmarkCell", forIndexPath: indexPath) as! BookmarkTableViewCell
        
        let yardSale = yardSales[indexPath.row]
        
        cell.configureCell(yardSale)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedYardSale = yardSales[indexPath.row]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
}

// MARK: Navigation

extension BookmarksViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailVC = segue.destinationViewController as? DetailTableViewController {
            detailVC.yardSaleID = selectedYardSale?.id
        }
    }
    
}