//
//  DashbordBonuspointsCELL.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/13/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import LinearProgressBar

class DashbordBonuASPCell: UITableViewCell {

    @IBOutlet weak var aspheader: UILabel!
    @IBOutlet weak var achementHeadder: UILabel!
    @IBOutlet weak var yorArHeadder: UILabel!
    @IBOutlet weak var progressBarone: LinearProgressBar!
    @IBOutlet weak var progressbarTwo: LinearProgressBar!
    
    @IBOutlet weak var targetArHeader: UILabel!
    @IBOutlet weak var targetValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
