//
//  FirstCustomTableViewCell.swift
//  Practica6
//
//  Created by Javier  Amor De La Cruz on 19/12/16.
//  Copyright © 2016 Javier  Amor De La Cruz. All rights reserved.
//

import UIKit

class FirstCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var result_label: UILabel!
    @IBOutlet weak var home_shield: UIImageView!
    @IBOutlet weak var visitor_shield: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
