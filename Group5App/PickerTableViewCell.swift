//
//  PickerTableViewCell.swift
//  Group5App
//
//  Created by Dan Lasker on 4/23/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import UIKit

class PickerTableViewCell: UITableViewCell {

    @IBOutlet weak var topicNTypePickerView: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
