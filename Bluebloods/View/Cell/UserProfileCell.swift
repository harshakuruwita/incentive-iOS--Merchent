//
//  UserProfileCell.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 10/3/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit

class UserProfileCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
