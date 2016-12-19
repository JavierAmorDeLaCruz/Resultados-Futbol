//
//  PartidosTableViewCell.swift
//  Practica6
//
//  Created by Carlos  on 19/12/16.
//  Copyright © 2016 Javier  Amor De La Cruz. All rights reserved.
//

import UIKit

class PartidosTableViewCell: UITableViewCell {

    @IBOutlet weak var localImg: UIImageView!
    @IBOutlet weak var visitorImg: UIImageView!
    @IBOutlet weak var localStr: UILabel!
    @IBOutlet weak var visitorStr: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var resultado: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
