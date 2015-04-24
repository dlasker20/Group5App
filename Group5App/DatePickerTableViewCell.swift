//
//  DatePickerTableViewCell.swift
//  Group5App
//
//  Created by Dan Lasker on 4/23/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
