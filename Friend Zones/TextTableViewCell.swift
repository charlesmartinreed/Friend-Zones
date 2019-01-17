//
//  TextTableViewCell.swift
//  Friend Zones
//
//  Created by Charles Martin Reed on 1/16/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
