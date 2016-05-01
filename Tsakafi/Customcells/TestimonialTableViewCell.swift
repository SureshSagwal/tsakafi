//
//  TestimonialTableViewCell.swift
//  Coffee
//
//  Created by Suresh Kumar on 21/04/16.
//  Copyright © 2016 Company. All rights reserved.
//

import UIKit

class TestimonialTableViewCell: UITableViewCell {

    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var designationLbl: UILabel!
    @IBOutlet var detailsLbl: UILabel!
    @IBOutlet var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
