//
//  BorderduiView.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 4/1/20.
//  Copyright © 2020 Bluebloods. All rights reserved.
//

import UIKit

class BorderduiView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
        
        
       layer.cornerRadius = 22.0
       layer.masksToBounds = true
       layer.borderColor = UIColor.white.cgColor
    layer.borderWidth = 1.5
        
       
    }

}
