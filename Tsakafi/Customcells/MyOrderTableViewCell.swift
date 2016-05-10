//
//  MyOrderTableViewCell.swift
//  Tsakafi
//
//  Created by Suresh Kumar on 05/05/16.
//  Copyright © 2016 Suri. All rights reserved.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {

    @IBOutlet var orderIdLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var amountLbl: UILabel!
    @IBOutlet var statusLbl: UILabel!
    @IBOutlet var viewDetailBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
