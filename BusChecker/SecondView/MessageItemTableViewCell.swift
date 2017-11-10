//
//  MessageItemTableViewCell.swift
//  BusChecker
//
//  Created by kenth on 2017-10-23.
//  Copyright © 2017 kenth. All rights reserved.
//

import UIKit

class MessageItemTableViewCell: UITableViewCell {

    @IBOutlet weak var dateTitle: UILabel!
    
    @IBOutlet weak var businfoLabel: UILabel!
    
    @IBOutlet weak var m1: UILabel!
    @IBOutlet weak var m2: UILabel!
    @IBOutlet weak var m3: UILabel!
    
    var messageO: MessageMO! 
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        dateTitle.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
