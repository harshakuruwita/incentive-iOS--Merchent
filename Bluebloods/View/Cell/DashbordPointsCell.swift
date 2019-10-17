//
//  DashbordPointsCell.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/13/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import LinearProgressBar

class DashbordPointsCell: UITableViewCell {

    @IBOutlet weak var batOne: LinearProgressBar!
    
    @IBOutlet weak var barTwo: LinearProgressBar!
    
    @IBOutlet weak var barOneValue: UILabel!
    @IBOutlet weak var barTwoValue: UILabel!
    @IBOutlet weak var frontValue: UILabel!
    
    @IBOutlet weak var cellHeader: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
