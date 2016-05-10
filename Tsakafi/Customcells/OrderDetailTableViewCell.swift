//
//  OrderDetailTableViewCell.swift
//  Tsakafi
//
//  Created by Suresh Kumar on 05/05/16.
//  Copyright © 2016 Suri. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {

    @IBOutlet var itemNameLbl: UILabel!
    @IBOutlet var weightLbl: UILabel!
    @IBOutlet var qtyLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var itemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
