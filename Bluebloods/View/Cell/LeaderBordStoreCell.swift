//
//  LeaderBordStoreCell.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/9/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit

class LeaderBordStoreCell: UITableViewCell {
    
    
    @IBOutlet weak var positionLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    

    @IBOutlet weak var roundUiView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         roundUiView.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
