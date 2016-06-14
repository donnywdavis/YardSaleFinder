//
//  PriceRangeTableViewCell.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/13/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class PriceRangeTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var priceRangeLabel: UILabel!
    
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

extension PriceRangeTableViewCell {
    
    func configureCell(yardSale: YardSale) {
        priceRangeLabel.text = "$0.99 - $20.00"
    }
    
}
