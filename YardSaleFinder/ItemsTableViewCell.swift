//
//  ItemsTableViewCell.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/13/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class ItemsTableViewCell: UITableViewCell {

    // MARK: IBOutlets
    
    @IBOutlet weak var itemsLabel: UILabel!
    
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

// MARK: Configure Cell

extension ItemsTableViewCell {
    
    func configureCell(yardSale: YardSale) {
        itemsLabel.text = yardSale.items?.stringByReplacingOccurrencesOfString(":", withString: "\n")
    }
    
}