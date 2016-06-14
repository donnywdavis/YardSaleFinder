//
//  AddressTableViewCell.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/13/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var addressLabel: UILabel!
    
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

// MARK: Cell Configuration

extension AddressTableViewCell {
    
    func configureCell(yardSale: YardSale) {
        addressLabel.text = yardSale.address?.stringByReplacingOccurrencesOfString(":", withString: "\n")
    }
    
}
