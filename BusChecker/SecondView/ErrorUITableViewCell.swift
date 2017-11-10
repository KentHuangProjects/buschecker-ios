//
//  ErrorUITableViewCell.swift
//  BusChecker
//
//  Created by kenth on 2017-11-09.
//  Copyright © 2017 kenth. All rights reserved.
//

import UIKit

class ErrorUITableViewCell: UITableViewCell {

 
    @IBOutlet weak var textview: UITextView!
    
    var messageO: MessageMO!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
