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
    
    
    var messageO: MessageMO! 
    
    @IBOutlet weak var messageTextfield: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
