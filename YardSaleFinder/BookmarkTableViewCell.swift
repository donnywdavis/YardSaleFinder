//
//  BookmarkTableViewCell.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/24/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
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

extension BookmarkTableViewCell {
    
    func configureCell(yardSale: YardSale) {
        addressLabel.text = yardSale.address?.multiLineDescription
        timeLabel.text = yardSale.formattedTime
    }
    
}